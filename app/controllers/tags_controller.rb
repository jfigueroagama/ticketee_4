class TagsController < ApplicationController
  
  def remove
    # We have a ticket
    @ticket = Ticket.find(params[:ticket_id])
    if can?("tag".to_sym, @ticket.project) || current_user.admin?
      @tag = Tag.find(params[:id])
      # Then we remove the tag from the tag's Array for the ticket, but it does not delete the tag from the DB
      @ticket.tags -= [@tag]
      @ticket.save
      # Does not render a new view. This returns a 200 status meaning that everything was OK
      #render :nothing => true
    end  
  end
  
end
