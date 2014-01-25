class Notifier < ActionMailer::Base
  default from: "jfigueroagama@gmail.com"
  
  def comment_update(comment, user)
    @comment = comment
    @user = user
    @ticket = comment.ticket
    @project = @ticket.project
    subject = "[ticketee] #{@project.name} - #{@ticket.title}"
    # The mail method generates a new emailpassing a hash with :to and :subject keys
    mail(:to => @user.email, :subject => subject)
  end
  
end
