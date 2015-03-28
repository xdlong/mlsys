class Erp::ProductsController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_erp_org,:set_erp_menu
  before_action :set_erp_product, only: [:show, :edit, :update, :destroy]
  layout 'erp'  
  def index
    @products = @menu.subject
    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end
  def new
    @product = Role::ManufacturedProduct.new()
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
    @product.product.destroy if @product.product
    @product.participation.dup.each{|part| part.destroy}
    @product.destroy
    respond_to do |format|
      format.html { redirect_to action:'index'}
      format.json { render json: true }
    end
  end
  private
  def set_erp_org
    @organization = Entity::Organization.find(params[:org_id])
  end
  def set_erp_menu
    @menu = Act::Classification.find(params[:menu_id])
  end
  def set_erp_product
    @product = Role::ManufacturedProduct.find(params[:id])
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