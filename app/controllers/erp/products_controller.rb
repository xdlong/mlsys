class Erp::ProductsController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_erp_menu
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
    @product = Entity::Product.new(erp_product_params)
    respond_to do |format|
      if @product.save
        format.html { redirect_to controller:'home', action:'index'}
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
        format.html { redirect_to controller:'home', action:'index'}
        format.json { render json: @product }
      else
        format.html { render 'edit'}
        format.json { render json: @product }
      end
    end
  end
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to controller:'home', action:'index'}
      format.json { render json: true }
    end
  end
  private
  def set_erp_menu
    @menu = Act::Classification.find(params[:menu_id])
  end
  def set_erp_product
    @product = Entity::Product.find(params[:id])
  end
  def erp_product_params
    params.require(:erp_product).permit(:title, :text, code: [:code, :display_name, :code_system], ii: [:root, :extension])
  end
end