class Erp::ProductsController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_erp_org,:set_erp_menu
  before_action :set_erp_product, only: [:show, :edit, :update, :destroy]
  layout 'erp'
  def index
    @products = (@menu ? @menu.subject : Entity::Product.where('ii.root'=>@organization.ii.root)).page(params[:page]).per(params[:per]||20)
    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end
  def new
    @product = Entity::Product.new()
    respond_to do |format|
      format.html
      format.json { render json: @product }
    end
  end
  def show
    respond_to do |format|
      format.html
      format.json { render json: @product }
    end
  end
  def edit
    respond_to do |format|
      format.html
      format.json { render json: @product }
    end
  end
  def create
    @product = Role::ManufacturedProduct.new(erp_product_params)
    @product.save
    subject = @menu.subject.new()
    subject.manufactured_product = @product
    respond_to do |format|
      if @menu.save
        format.html { redirect_to action:'index'}
        format.json { render json: @product }
      else
        format.html { render 'new'}
        format.json { render json: @product }
      end
    end
  end
  def update
    @product = Role::ManufacturedProduct.find(params[:id])
    respond_to do |format|
      if @product.update_attributes(erp_product_params)
        format.html { redirect_to action:'index'}
        format.json { render json: @product }
      else
        format.html { render 'edit'}
        format.json { render json: @product }
      end
    end
  end
  def destroy
    @product.playeds.dup.each do |role|
      role.participation.dup.each do |part|
        part.destroy if part.act.is_a?(Act::Classification)
      end
      role.destroy unless role.participation.present?
    end
    @product.destroy
    respond_to do |format|
      format.html { redirect_to action:'index'}
      format.json { render json: true }
    end
  end
  def array_list
    list = @menu ? @menu.subject.map{|subject| role = subject.manufactured_product; {
      ii:role.ii.extension,
      name:role.product.name.to_s,
      qty:role.product.quantity.to_s,
      unit:role.product.quantity.unit,
      desc:role.product.desc
      } if role}.compact : Entity::Product.where('ii.root'=>@organization.ii.root).map{|product| {
        ii:product.ii.extension,
        name:product.name.to_s,
        qty:product.quantity.to_s,
        unit:product.quantity.unit.to_s,
        desc:product.desc
        }}
    render json: list.to_json # [{ii:'1322',name:'3453e',qty:'34 tc',unit:'tc',desc:'dghdsh'}]
  end
  private
  def set_erp_org
    @organization = Entity::Organization.find(params[:org_id])
    @menus = (recs = @organization.as_located_entity.last.try(:receiver)) ? recs.asc('priority_number') : []
  end
  def set_erp_menu
    @menu = Act::Classification.find(params[:menu_id]) if params[:menu_id]
  end
  def set_erp_product
    @product = Entity::Product.find(params[:id])
  end
  def erp_product_params
    attrs = params.require(:erp_product).permit(:name, :desc, :product_id, quantity:[:value, :unit], code: [:code, :display_name, :code_system], ii: [:root, :extension]).deep_symbolize_keys
    {
      ii: attrs[:ii],
      code: attrs[:code],
      name: attrs[:name],
      desc: attrs[:desc],
      product: {
        id:attrs[:product_id],
        ii:attrs[:ii],
        code: attrs[:code],
        name: attrs[:name],
        quantity: attrs[:quantity]
      }
    }
  end
end