class Api::V1::ProjectsController < Api::V1::BaseController
  # The response to the json request will be serialized json response
  # calling to_json in the response. Rails takes care of that do to
  # the respond_to :json in the Api::V1::BaseController
  def index
    # We use the for scope defined in the Project model
    # We use load instead of all which is deprecated
    respond_with(Project.for(current_user).load)
  end
  
  def create
    # By attempting to save the project, the application
    # will run the validations for a project. If succeeds
    # returns status 201 andthe proper representation of
    # the project, JSON or XML
    project = Project.new(project_params)
    if project.save
      # here we set the Location key for the headers passing
      # the :location option to the right URL: hhtp://example.com/api/v1/projects/1
      # rather than the default for Rails http://example.com/projects/1
      respond_with(project, :location => api_v1_project_path(project))
    else
      # if we have errors, then we will return the response that will contaimg the errors
      respond_with(project)
    end
  end
  
  private
  
  def project_params
    params.require(:project).permit(:name, :description)
  end
  
end