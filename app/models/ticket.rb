class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :state
  has_many :comments
  
  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }
end
