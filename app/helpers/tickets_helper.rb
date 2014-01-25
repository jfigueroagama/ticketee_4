module TicketsHelper
  def state_for(comment)
    content_tag(:div, :class => "states") do
      if comment.state
        previous_state = comment.previous_state
        if previous_state && comment.state != previous_state
          "#{render previous_state} &rarr; #{render comment.state}"
        else
          "#{render comment.state}"
        end
      end
    end
  end
  
  def toggle_watching_button
    if @ticket.watchers.include?(current_user)
      text = "Stop watching this ticket"
    else
      text = "Watch this ticket"
    end
    # button_to method works similar to link_to 0> gives a way to go semewhere else
    # in this case submmits the form through a POST request to an action in tickets
    # controller. The only parameter passed through params[:commit] is the text
    button_to(text, watch_project_ticket_path(@ticket.project, @ticket))
  end
end
