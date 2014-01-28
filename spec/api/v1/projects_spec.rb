require 'spec_helper'

describe "/api/v1/projects", :type => :api do
  let!(:user) { FactoryGirl.create(:user) }
  # This the token set up by the let!(:user)
  let!(:token) { user.access_token }
  let!(:project) { FactoryGirl.create(:project) }
  
  before do
    user.permissions.create!(action: "view", thing: project)
  end
  
  context "projects viewable by user" do
    let(:url) {"/api/v1/projects"}
    let!(:project_no_access) { FactoryGirl.create(:project, name: "Access Denied")}
    
    it "json" do
      # This get method is provided by Rack::Test::Methods and makes
      # a GET request to the URL delined by let(url)
      get "#{url}.json", :token => token
      # We use thr for scope defined in the Project model
      projects_json = Project.for(user).load.to_json
      response.body.should eql(projects_json)
      # HTTP status code = 200 is OK
      response.status.should eql(200)
      # The JSON.parse method is provided by json gem that converts into Ruby Array or Hash
      projects = JSON.parse(response.body)
      # We use the response to verify that we have the right information
      projects.any? do |p|
        p["name"] == project.name
      end.should be_true
      # The project "Access Denied" should not be viewable by the user
      projects.any? do |p|
        p["name"] == "Access Denied"
      end.should_not be_true
    end
    
  end
end
