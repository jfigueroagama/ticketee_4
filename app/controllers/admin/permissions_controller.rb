class Admin::PermissionsController < Admin::BaseController
  before_action :set_user
  
  def index
    @ability = Ability.new(@user)
    @projects = Project.all
  end
  
  def set
    # First, we clear all permissions
    @user.permissions.clear
    # We iterate trough permissions
    params[:permissions].each do |id, permissions|
      # Find the project
      project = Project.find(id)
      # Define permissions for that project
      permissions.each do |permission, checked|
        Permission.create!(user: @user, thing: project, action: permission)
      end
    end
    flash[:notice] = "Permissions updated."
    redirect_to admin_user_permissions_path(@user)
  end
  
  private
  
  def set_user
    @user = User.find(params[:user_id])
  end
  
end
