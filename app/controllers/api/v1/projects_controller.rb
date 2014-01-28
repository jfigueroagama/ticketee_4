class Api::V1::ProjectsController < Api::V1::BaseController
  # The response to the json request will be serialized json response
  # calling to_json in the response. Rails takes care of that do to
  # the respond_to :json in the Api::V1::BaseController
  def index
    # We use the for scope defined in the Project model
    # We use load instead of all which is deprecated
    respond_with(Project.for(current_user).load)
  end
end