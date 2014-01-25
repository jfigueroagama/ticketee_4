class CommentObserver < ActiveRecord::Observer
  # This method will be called after a comment is crested
  def after_create(comment)
    # Get the list of watchers to the ticket and takes out the user creating the comment
    (comment.ticket.watchers - [comment.user]).each do |user|
      # The comment_update method will create an email for each watcher
      Notifier.comment_update(comment, user).deliver
    end
  end
end