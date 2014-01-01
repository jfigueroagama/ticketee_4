class TicketsController < ApplicationController
  # Since tickets belongs to a project and to ALL ACTIONS IN THE PROJECT the user must signed in
  # For tickets we must require signed in users for ALL ACTIONS IN THE TICKET which defines current_user
  before_action :require_signin!#, except: [:show, :index]
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  
  
  def new
    @ticket = @project.tickets.build
  end
  
  def create
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
  
  private
  
  def ticket_params
    params.require(:ticket).permit(:title, :description)
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
end
