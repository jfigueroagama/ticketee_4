class TicketsController < ApplicationController
  # Since tickets belongs to a project and to ALL ACTIONS IN THE PROJECT the user must signed in
  # For tickets we must require signed in users for ALL ACTIONS IN THE TICKET which defines current_user
  before_action :require_signin!#, except: [:show, :index]
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :watch]
  # The authorization to create tickets is handled by cancan
  before_action :authorize_create!, only: [:new, :create]
  before_action :authorize_update!, only: [:edit, :update]
  before_action :authorize_delete!, only: :destroy
  
  
  def new
    @ticket = @project.tickets.build
  end
  
  def show
    @comment = @ticket.comments.build
    @states = State.all
  end
  
  def create
    # we erase tag_names from params for a user without permission to create tags
    # we check the user permissions with the cancan cannot? method
    if !current_user.admin? && cannot?("tag".to_sym, @project)
      params[:ticket].delete(:tag_names)
    end
    # strong params is an addition on Rails 4
    @ticket = @project.tickets.build(ticket_params)
    # here we use the setter method for ticket's user
    @ticket.user = current_user
    if @ticket.save
      flash[:notice] = "Ticket has been created."
      redirect_to [@project, @ticket]
    else
      flash[:alert] = "Ticket has not been created."
      render "new"
    end
  end
  
  def edit
    # empty because we have defined set_ticket method before edit
  end
  
  def update
    if @ticket.update(ticket_params)
      flash[:notice] = "Ticket has been updated."
      redirect_to [@project, @ticket]
    else
      flash[:alert] = "Ticket has not been updated."
      render action: "edit"
    end
  end
  
  def destroy
    @ticket.destroy
    flash[:notice] = "Ticket has been deleted."
    redirect_to @project
  end
  
  def search
    @tickets = @project.tickets.search(params[:search])
    render "projects/show"
  end
  
  def watch
    # we did not set up the @ticket instance variable because we added this
    # action to the before_filter set_ticket
    if @ticket.watchers.exists?(current_user)
      @ticket.watchers -= [current_user]
      flash[:notice] = "You are no longer watching this ticket."
    else
      @ticket.watchers << current_user
      flash[:notice] = "You are now watching this ticket."
    end
    redirect_to project_ticket_path(@ticket.project, @ticket)
  end
  
  private
  
  def ticket_params
    params.require(:ticket).permit(:title, :description, :tag_names)
  end
  
  def set_project
    @project = Project.for(current_user).find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The project you were looking for could not be found."
    redirect_to root_path
  end
  
  def set_ticket
    @ticket = @project.tickets.find(params[:id])
  end
  
  def authorize_create!
    # cannot? is a method defined by cancan gem, Returns true or false whether the user can do
    # a particular action. This method an can? may be used in controllers and views
    if !current_user.admin? && cannot?("create tickets".to_sym, @project)
      flash[:alert] = "You cannot create tickets on this project."
      redirect_to @project
    end
  end
  
  def authorize_update!
    if !current_user.admin? && cannot?("edit tickets".to_sym, @project)
      flash[:alert] = "You cannot edit tickets on this project."
      redirect_to @project
    end
  end
  
  def authorize_delete!
    if !current_user.admin? && cannot?("delete tickets".to_sym, @project)
      flash[:alert] = "You cannot delete tickets on this project."
      redirect_to @project
    end
  end
end
