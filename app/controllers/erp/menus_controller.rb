#encoding:utf-8
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
        format.html { redirect_to controller:'orgs', action:'show', id:@organization.id}
        format.json { render json: @menu }
      else
        format.html { render 'edit'}
        format.json { render json: @menu }
      end
    end
  end
  def destroy
    unless @menu.component.present?||@menu.subject.present?
      @menu.inbounds.dup.each{|rela| rela.destroy}
      @menu.outbounds.dup.each{|rela| rela.destroy}
      @menu.participation.dup.each{|part| part.destroy}
      @menu.destroy
    end
    respond_to do |format|
      format.html { redirect_to controller:'orgs', action:'show', id:@organization.id}
      format.json { render json: true }
    end
  end
  def init
    menus = YAML.load_file(Rails.root+"config/init_ymls/product_menu.yml").deep_symbolize_keys[:menu]
    as_located_entity = @organization.as_located_entity.last
    as_located_entity ||= @organization.as_located_entity.new()
    menus[:receiver].each do |receiver_elm|
      receiver_elm.deep_symbolize_keys!
      menu = add_menu({classification: receiver_elm.delete(:classification)})
      receiver = as_located_entity.receiver.new(receiver_elm)
      receiver.classification = menu
      receiver.save
    end
    as_located_entity.save
    @organization.save
    render json: menus.to_json
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
  def add_menu attrs
    attrs.deep_symbolize_keys!
    components = attrs[:classification].delete(:component)||[]
    ret = Act::Classification.new(attrs[:classification])
    components.each do |component_elm|
      menu = add_menu({classification: component_elm.delete(:classification)})
      component = ret.component.new(component_elm)
      component.classification = menu
      component.save
    end
    ret.save
    ret
  end
end