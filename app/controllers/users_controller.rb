class UsersController < ActionController::Base
  before_action :authenticate_user!
  layout 'user'
  def index
  end
end
