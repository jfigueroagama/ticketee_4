module AuthorizationHelpers
  
  def define_permission!(user, action, thing)
    # We create a permission object in the Permission model
    Permission.create!(user: user,action: action, thing: thing)
  end
end

RSpec.configure do |c|
  c.include AuthorizationHelpers
end
