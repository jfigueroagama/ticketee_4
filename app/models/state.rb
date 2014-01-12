class State < ActiveRecord::Base
  has_many :comments
  has_many :tickets
end
