module ApplicationHelper
  
  def title(*parts)
    unless parts.empty?
      content_for :title do
        (parts << "Ticketee").join(" - ")
      end
    end
  end
  
  # Checking if a user is admin can be used from anywhere in our application
  # so we put it in the ApplicationHelper where it is available for any view
  # the method takes a block which is the call between the do and end inside the view
  # To run this block, we use block.call which runs if current_user.try(:admin?) returns true
  # try runs a method on an object and if that method does not exists returns nil
  # if current_user is not admin, it will return nil instead of NoMethodError
  def admins_only(&block)
    #p current_user
    block.call if current_user.try(:admin?)
  end
  
end
