class Api::V1::ProjectsController < Api::V1::BaseController
  before_filter :authorize_admin!, :except => [:index, :show]
  before_filter :set_project, :only => [:show, :update, :destroy]
  # The response to the json request will be serialized json response
  # calling to_json in the response. Rails takes care of that do to
  # the respond_to :json in the Api::V1::BaseController
  def index
    # We use the for scope defined in the Project model
    # We use load instead of all which is deprecated
    respond_with(Project.for(current_user).load)
  end
  
  def show
    # If a method is not defined but it is specified
    # in ;methods options, it is ignored
    # the last_ticket will be defined in the project
    # model through the association with tickets
    #@project = Project.find(params[:id])
    respond_with(@project, :methods => "last_ticket")
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
  
  def update
    # The update_attributes saves the object and returs 
    # a valid object in the format we asked for (json)
    # If the object fails validation, the status code
    # returned will be 422 => Unprocessable entity and the
    # response will contain the errors. If the object is valid
    # but we get an empty response, we will get a status code 204
    @project.update_attributes(project_params)
    respond_with(@project)
  end
  
  def destroy
    @project.destroy
    respond_with(@project)
  end
  
  private
  
  def project_params
    params.require(:project).permit(:name, :description)
  end
  
  def set_project
    @project = Project.for(current_user).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error = { :error => "The project you are looking for could not be found."}
    respond_with(error, {:status => 404})
  end
  
end