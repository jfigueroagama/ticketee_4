class ProjectsController < ApplicationController
  before_action :require_signin!#, only: [:show, :index] ALL ACTION IN PROJECT CONTROLLER REQUIRE SIGN IN
  before_action :authorize_admin!, except: [:show, :index] # :authorize_admin! uses :require_signin!
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  
  def index
    # We should restrict the list of projects thst the user is allowed to see
    # The user must be signed in before the index action otherwise we do not have current user
    @projects = Project.for(current_user)
  end
  
  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(project_params)   
    if @project.save
      flash[:notice] = "Project has been created!"
      redirect_to @project
    else
      flash[:alert] = "Project has not been created"
      render "new"
    end
  end
  
  def show
    #@project = Project.find(params[:id])
  end
  
  def edit
    #@project = Project.find(params[:id])
  end
  
  def update
    #@project = Project.find(params[:id])
    if @project.update(project_params)
      flash[:notice] = "Project has been updated."
      redirect_to @project
    else
      flash[:alert] = "Project has not been updated."
      render "edit"
    end
  end
  
  def destroy
    #@project = Project.find(params[:id])
    @project.destroy
    flash[:notice] = "Project has been deleted."
    redirect_to projects_path
  end
  
  private
  
  def project_params
    params.require(:project).permit(:name, :description)
  end
  
  def set_project
  #if current_user.admin?
    #@project = Project.find(params[:id])
  #else
    #@project = Project.viewable_by(current_user).find(params[:id])
  #end
  @project = Project.for(current_user).find(params[:id])
  # If the project is not found raises an exception which is rescue and redirected to project index => root_path
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The project you were looking for could not be found."
    redirect_to root_path
  end
  
end
