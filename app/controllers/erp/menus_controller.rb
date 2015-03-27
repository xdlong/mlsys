class Erp::MenusController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_erp_org, :set_pre_menu
  before_action :set_erp_menu, only: [:show, :edit, :update, :destroy]
  layout 'erp'
  def new
    @menu = Act::Classification.new()
    respond_to do |format|
      format.html
      format.json { render json: @menu }
    end
  end
  def show
    respond_to do |format|
      format.html
      format.json { render json: @menu }
    end
  end
  def edit
    respond_to do |format|
      format.html
      format.json { render json: @menu }
    end
  end
  def create
    @menu = Act::Classification.new(erp_menu_params)
    if @pre_menu
      component = @pre_menu.component.new()
      component.classification = @menu
      data = @pre_menu
    else
      as_located_entity = @organization.as_located_entity.last
      as_located_entity ||= @organization.as_located_entity.new()
      receiver = as_located_entity.receiver.new()
      receiver.classification = @menu
      data = as_located_entity.new_record? ? @organization : as_located_entity
    end
    respond_to do |format|
      if data.save
        format.html { redirect_to controller:'orgs', action:'show', id:@organization.id}
        format.json { render json: @menu }
      else
        format.html { render 'new'}
        format.json { render json: @menu }
      end
    end
  end
  def update
    respond_to do |format|
      if @menu.update_attributes(erp_menu_params)
        format.html { redirect_to controller:'home', action:'index'}
        format.json { render json: @menu }
      else
        format.html { render 'edit'}
        format.json { render json: @menu }
      end
    end
  end
  def destroy
    @menu.destroy unless @menu.component.present?||@menu.subject.present?
    respond_to do |format|
      format.html { redirect_to controller:'home', action:'index'}
      format.json { render json: true }
    end
  end
  private
  def set_erp_org
    @organization = Entity::Organization.find(params[:org_id])
  end
  def set_pre_menu
    @pre_menu = params[:pre_menu_id] ? Act::Classification.find(params[:pre_menu_id]) : nil
  end
  def set_erp_menu
    @menu = Act::Classification.find(params[:id])
  end
  def erp_menu_params
    params.require(:erp_menu).permit(:title, :text, code: [:code, :display_name, :code_system], ii: [:root, :extension])
  end
end