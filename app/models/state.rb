class State < ActiveRecord::Base
  has_many :comments
  has_many :tickets
  
  # This method can be use any time you have an instance of this model
  def default!
    current_default_state = State.find_by_default(true)  
    self.default = true
    self.save!   
    if current_default_state
      current_state_default.default = false
      current_state_default.save!
    end
     
  end
end
