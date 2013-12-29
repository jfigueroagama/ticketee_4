class User < ActiveRecord::Base
  has_secure_password
  has_many :tickets
  has_many :permissions
  
  validates :email, presence: true
  
  # This overrides the to_s ruby method
  def to_s
    "#{email} (#{admin? ? "Admin":"User"})"
  end
end
