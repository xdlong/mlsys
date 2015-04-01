class Erp::SetupsController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_erp_org
  layout 'erp'
  def index
  end
  private
  def set_erp_org
    @organization = Entity::Organization.find(params[:org_id])
  end
end
