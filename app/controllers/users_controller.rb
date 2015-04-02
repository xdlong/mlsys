class UsersController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_user, only: [:unlock,:lock,:confirm]
  layout 'user'
  def index
    @users = User.all.page(params[:page]).per(params[:per]||20)
  end
  def unlock
    @user.unlock_access! if @user.unlock_token == params[:unlock_token]
    redirect_to action: 'index'
  end
  def lock
    @user.lock_access!
    redirect_to action: 'index'
  end
  def confirm
    @user.confirm! if @user.confirmation_token == params[:confirmation_token]
    redirect_to action: 'index'
  end
  private
  def set_user
    @user = User.find(params[:user_id])
  end
end
