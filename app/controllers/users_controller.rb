class UsersController < ActionController::Base
  before_action :authenticate_user!
  layout 'user'
  def index
  	@users = User.all.page(params[:page]).per(params[:per]||20)
  end
end
