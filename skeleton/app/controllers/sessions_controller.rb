class SessionsController < ApplicationController
  before_action :already_logged_in?, only: [:new, :create]
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    login!(@user)
    redirect_to cats_url
  end
  
  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end
  
  def already_logged_in?
    redirect_to cats_url if logged_in? 
  end
  
  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end