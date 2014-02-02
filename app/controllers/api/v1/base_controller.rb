class Api::V1::BaseController < ActionController::Base
  # This is the Base class for all controllers for V1 of the Project API
  # The Project API will respond to json requests
  respond_to :json, :xml
  before_filter :authenticate_user
  before_filter :check_rate_limit
  
  private 
  
  def authenticate_user
    # This a getter method which defines the instance variable @current_user
    # If we make a request with invalid token, this will return nil
    @current_user = User.find_by_access_token(params[:token])
    unless @current_user
      respond_with({ :error => "Token is invalid." })
    end
  end
  
  def check_rate_limit
    if @current_user.request_count > 100
      # If the request_count for the user exceeds 100,
      # we return a forbidden request, status code => 403
      error = { :error => "Rate limit exceeded."}
      respond_with(error, :status => 403)
    else
      # We increment the number of requests done by the user
      @current_user.increment!(:request_count)
    end  
  end
  
  def authorize_admin!
    if !current_user.admin?
      error = { :error => "You must be an admin to do that."}
      render params[:format].to_sym => error, :status => 401
    end
  end
  
  def current_user
    # This is a BAU setter method
    @current_user
  end
end