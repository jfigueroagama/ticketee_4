class CommentsController < ApplicationController
  before_action :require_signin!
  before_action :set_ticket
  
  def create
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
  
  def comments_params
    params.require(:comment).permit(:text, :state_id)
  end
  
  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end
end
