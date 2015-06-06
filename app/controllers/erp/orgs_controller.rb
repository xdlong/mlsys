class Erp::OrgsController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_erp_org, only: [:show, :edit, :update, :destroy]
  layout 'erp'
  def new
    @organization = Entity::Organization.new()
    respond_to do |format|
      format.html
      format.json { render json: @organization }
    end
  end
  def show
    @menus = (recs = @organization.as_located_entity.last.try(:receiver)) ? recs.asc('priority_number') : []
    match=Regexp.new params[:search].to_s
    @products = Entity::Product.where('ii.root'=>@organization.ii.root).any_of({'ii.extension'=>match},{name:match},{desc:match}).page(params[:page]).per(params[:per]||15)
    respond_to do |format|
      format.html
      format.json { render json: @organization }
    end
  end
  def edit
    respond_to do |format|
      format.html
      format.json { render json: @organization }
    end
  end
  def create
    @organization = Entity::Organization.new(erp_org_params)
    respond_to do |format|
      if @organization.save
        format.html { redirect_to controller:'home', action:'index'}
        format.json { render json: @organization }
      else
        format.html { render 'new'}
        format.json { render json: @organization }
      end
    end
  end
  def update
    respond_to do |format|
      if @organization.update_attributes(erp_org_params)
        format.html { redirect_to controller:'home', action:'index'}
        format.json { render json: @organization }
      else
        format.html { render 'edit'}
        format.json { render json: @organization }
      end
    end
  end
  def destroy
    @organization.playeds.dup.each{|role| role.destroy}
    @organization.scopeds.dup.each{|role| role.destroy}
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to controller:'home', action:'index'}
      format.json { render json: true }
    end
  end
  private
  def set_erp_org
      @organization = Entity::Organization.find(params[:id])
    end
  def erp_org_params
    params.require(:erp_org).permit(:name, :desc, ii: [:root, :extension])
  end
end