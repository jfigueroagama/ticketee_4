class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    # We get the users ordered by email
    @users = User.order(:email)
  end
  
  def show
    #@user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    params = user_params.dup
    params[:password_confirmation] = params[:password]
    @user = User.new(params)
    
    if @user.save
      flash[:notice] = "User has been created."
      redirect_to admin_users_path # redirects to index path
    else
      flash[:alert] = "User has not been created."
      render "new"
    end
  end
  
  def edit
    #@user = User.find(params[:id])
  end
  
  def update
    # If the user leaves the password blank we keep the previous password
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    
    if @user.update_attributes(user_params)
      flash[:notice] = "User has been updated."
      redirect_to admin_users_path
    else
      flash[:alert] = "User has not been updated."
      render "edit"
    end
  end
  
  def destroy
    if @user == current_user
      flash[:alert] = "You cannot delete yourself!"
    else
      @user.destroy
      flash[:notice] = "User has been deleted."
    end
    redirect_to admin_users_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
end
