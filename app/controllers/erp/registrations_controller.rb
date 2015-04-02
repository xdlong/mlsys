class Erp::RegistrationsController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_erp_org,:set_erp_menu
  before_action :set_erp_reg, only: [:show, :edit, :update, :destroy]
  layout 'erp'
  def index
    @regs = Act::Registration.where('ii.root'=>@organization.ii.root,'code.code'=>params[:code]).page(params[:page]).per(params[:per]||12)
    respond_to do |format|
      format.html
      format.json { render json: @regs }
    end
  end
  def new
    @reg = Act::Registration.new(code:{code:params[:code]})
    respond_to do |format|
      format.html
      format.json { render json: @reg }
    end
  end
  def show
    respond_to do |format|
      format.html
      format.json { render json: @reg }
    end
  end
  def edit
    respond_to do |format|
      format.html
      format.json { render json: @reg }
    end
  end
  def create
    attrs = erp_reg_params
    products = attrs.delete(:subject)
    menu_id = attrs[:coverage][0][:classification][:id]
    @reg = Act::Registration.new(attrs)
    menu = Act::Classification.find(menu_id) if menu_id.present?
    products.each_with_index do |product_elm,i|
      next unless product_elm[:ii][:extension].present?
      product = Entity::Product.where('ii.root'=>product_elm[:ii][:root],'ii.extension'=>product_elm[:ii][:extension]).last
      product ||= Entity::Product.new(product_elm) if menu_id.present?
      next unless product
      nqty = product_elm[:quantity]
      if product.new_record?
        product.save
        role = Role::ManufacturedProduct.new(product_elm)
        role.product = product
        role.save
        subject = menu.subject.new()
        subject.manufactured_product = role
        subject.save
        menu.save
      else
        case attrs[:code][:code]
        when '0' # 入库
          qty = product.quantity
          product.update_attributes(quantity:{value:qty.value.to_i+nqty[:value].to_i,unit:qty.unit})
        when '1' # 出库
          qty = product.quantity
          product.update_attributes(quantity:{value:qty.value.to_i-nqty[:value].to_i,unit:qty.unit})
        end
      end
      role = Role::ManufacturedProduct.new(product_elm)
      role.product = product
      role.save
      subject = @reg.subject.new(priority_number:i)
      subject.manufactured_product = role
      subject.save
    end
    respond_to do |format|
      if @reg.save
        format.html { redirect_to action:'new', code:attrs[:code][:code]}
        format.json { render json: @reg }
      else
        format.html { render 'new'}
        format.json { render json: @reg }
      end
    end
  end
  def update
    respond_to do |format|
      if @reg.update_attributes(erp_reg_params)
        format.html { redirect_to action:'index', code:'0'}
        format.json { render json: @reg }
      else
        format.html { render 'edit'}
        format.json { render json: @reg }
      end
    end
  end
  def destroy
    code = @reg.code.code
    @reg.subject.dup.each{|subject| subject.manufactured_product.destroy if subject.manufactured_product;subject.destroy}
    @reg.coverage.dup.each{|coverage| coverage.destroy}
    @reg.destroy
    respond_to do |format|
      format.html { redirect_to action:'index', code:code}
      format.json { render json: true }
    end
  end
  private
  def set_erp_org
    @organization = Entity::Organization.find(params[:org_id])
    @menus = (recs = @organization.as_located_entity.last.try(:receiver)) ? recs.asc('priority_number') : []
  end
  def set_erp_menu
    @menu = Act::Classification.find(params[:menu_id]) if params[:menu_id]
  end
  def set_erp_reg
    @reg = Act::Registration.find(params[:id])
  end
  def erp_reg_params
    attrs = params.require(:erp_reg).deep_symbolize_keys
    {
      ii: attrs[:ii],
      code: attrs[:code],
      text: attrs[:desc],
      coverage: [{classification:attrs[:menu]}],
      subject: attrs[:products].map{|k,v| v.merge({ii:{root:attrs[:ii][:root],extension:v[:ii][:extension]}})}
    }
  end
end