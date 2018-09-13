class UsersController < ApplicationController
  before_action :already_logged_in?, only: [:new, :create]
  
  def index
    @users = User.all
    render :index
  end
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      redirect_to cats_url
    else
      flash[:errors] = @user.errors.full_messages
    end
  end
  
  def already_logged_in?
    redirect_to cats_url if logged_in?
  end
  
  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end