class Erp::HomeController < ActionController::Base
  before_action :authenticate_user!
  layout 'erp'
  def index
  	@organizations = Entity::Organization.all
    respond_to do |format|
      format.html
      format.json { render json: @organizations }
    end
  end
end
