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
  end
end
