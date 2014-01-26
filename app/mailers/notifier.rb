class Notifier < ActionMailer::Base
  # This is sending the email as configured in config/initializers/mail.rb
  # and will set the display name to "Ticketee"
  from_address = ActionMailer::Base.smtp_settings[:user_name]
  default from: "Ticketee <#{from_address}>"
  
  
  def comment_update(comment, user)
    @comment = comment
    @user = user
    @ticket = comment.ticket
    @project = @ticket.project
    subject = "[ticketee] #{@project.name} - #{@ticket.title}"
    # The mail method generates a new email passing a hash with :to, :subject and :reply_to keys
    # Here we are setting the reply address to MY GMAIL ACCOUNT: jfigueroagama@gmail.com
    mail(:to => @user.email, :subject => subject, :reply_to => "jfigueroagama+" + "#{@project.id}+#{@ticket.id}@gmail.com")
  end
  
end
