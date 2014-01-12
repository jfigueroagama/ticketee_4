class Comment < ActiveRecord::Base
  before_create :set_previous_state
  after_create :set_ticket_state
  
  # delegates methos allows to use the ticket association with project
  # taking advantange of the assocition between ticket and comment
  delegate :project, to: :ticket
  
  belongs_to :ticket
  belongs_to :user
  belongs_to :state
  # defines an association within the same comments table to define the previous_state
  belongs_to :previous_state, class_name: "State"
  
  validates :text, presence: true
  
  private
  
  def set_previous_state
    self.previous_state = ticket.state
  end
  
  def set_ticket_state
    # makes the ticket state equals to the comment state
    self.ticket.state = self.state
    self.ticket.save!
  end
end
