# Here we define a module => ApiHelper which will be included ti any test marked :type => :api
module ApiHelper
  include Rack::Test::Methods
  
  # This is done so to teh module knows in which application is acting on
  def app
    Rails.application
  end
  
end

RSpec.configure do |c|
  c.include ApiHelper, :type => :api
end
