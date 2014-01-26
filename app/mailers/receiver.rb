class Receiver < ActionMailer::Base
  
  def self.parse(email)
    # We define a regex with the reply separator
    reply_separator = /(.*?)\s?== ADD YOUR REPLY ABOVE THIS LINE ==/m
    comment_text =reply_separator.match(email.body.to_s)
    if comment_text # if you get the separator
      # We use the split (string => array) method to get the project.id and ticket.id
      # The [0] element of the array gets the account and then it gets the project.id and ticket.id
      to, project_id, ticket_id = email.to.first.split("@")[0].split("+")
      domain = email.to.first.split("@")[1]
      # Now we find the project and ticket for the reply
      project = Project.find(project_id)
      ticket = project.tickets.find(ticket_id)
      user = User.find_by_email(to + "@" + domain)
      # Then we create a new comment
      ticket.comments.create({
        :text => comment_text[1].strip,
        :user => user
      })
    end
  end
end
