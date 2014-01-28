class Api::V1::BaseController < ActionController::Base
  # This is the Base class for all controllers for V1 of the Project API
  # The Project API will respond to json requests
  respond_to :json
  before_filter :authenticate_user
  
  private 
  
  def authenticate_user
    @current_user = User.find_by_access_token(params[:token])
  end
  
  def current_user
    @current_user
  end
end