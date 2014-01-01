class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # When the user signs up, it must be signed in also
      # We store the user is in the session hash
      session[:user_id] = @user.id
      flash[:notice] = "You have signed up successfully."
      redirect_to projects_path
    else
      render "new"
    end
  end

  def show
    #@user = User.find(params[:id])
  end
  
  def edit
    #@user = User.find(params[:id])
  end
  
  def update
    #@user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "Profile has been updated."
      redirect_to user_path(@user)
    else
      flash[:alert] = "Profile has not been updated."
      render action: "edit"
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
end
