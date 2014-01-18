class CommentsController < ApplicationController
  before_action :require_signin!
  before_action :set_ticket
  
  def create
    sanitize_parameters!
    @comment = @ticket.comments.build(comments_params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Comment has been created."
      redirect_to [@ticket.project, @ticket]
    else
      @states = State.all
      flash[:alert] = "Comment has not been created."
      # template: options renders a template of another controller => tickets
      # render method does not call the action, so the code within the show
      # action of the tickets controller won't be executed
      render template: "tickets/show"
    end
  end
  
  private
  
  def sanitize_parameters!
    # we erase state_id from params for a user without permission to change states
    # we check the user permissions with the cancan cannot? method
    if !current_user.admin? && cannot?("change states".to_sym, @ticket.project)
      params[:comment].delete(:state_id)
    end
    # we erase tag_names from params for a user without permission to create tags
    # we check the user permissions with the cancan cannot? method
    if !current_user.admin? && cannot?("tag".to_sym, @ticket.project)
      params[:comment].delete(:tag_names)
    end
  end
  
  def comments_params
    params.require(:comment).permit(:text, :state_id, :tag_names)
  end
  
  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end
end
