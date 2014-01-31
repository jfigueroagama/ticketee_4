require 'spec_helper'

describe "Project API errors", :type => :api do
  context "standard users" do
    let(:user) { FactoryGirl.create(:user) }
    
    it "cannot create projects" do
      post "/api/v1/projects.json", :token => user.access_token, :project => { name: "My Project" }
      error = { :error => "You must be an admin to do that." }
      
      response.body.should eql(error.to_json)
      # status code 401 => "Unauthorized"
      response.status.should eql(401)
      Project.find_by_name("My Project").should be_nil
    end
    
    it "cannot view projects they do not have access" do
      other_project = FactoryGirl.create(:project)
      get "/api/v1/projects/#{other_project.id}.json", :token => user.access_token
      error = { :error => "The project you are looking for could not be found."}
      # The project resource could not be found => 404
      response.status.should eql(404)
      response.body.should eql(error.to_json)
    end
  end
end
