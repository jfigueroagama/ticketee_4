class Project < ActiveRecord::Base
  validates :name, presence: true
  # If we have callbacks use dependent: :destroy
  has_many :tickets, dependent: :delete_all
end
