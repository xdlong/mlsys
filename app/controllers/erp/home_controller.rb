class Erp::HomeController < ActionController::Base
  before_action :authenticate_user!
  layout 'erp'
  def index
  end
end
