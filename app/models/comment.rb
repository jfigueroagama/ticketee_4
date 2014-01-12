class Comment < ActiveRecord::Base
  after_create :set_ticket_state
  
  # delegates methos allows to use the ticket association with project
  # taking advantange of the assocition between ticket and comment
  delegate :project, to: :ticket
  
  belongs_to :ticket
  belongs_to :user
  belongs_to :state
  
  validates :text, presence: true
  
  private
  
  def set_ticket_state
    # makes the ticket state equals to the comment state
    self.ticket.state = self.state
    self.ticket.save!
  end
end
