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
    
    it "xml" do
      get "#{url}.xml", :token => token
      response.body.should eql(Project.for(user).load.to_xml)
      # nokogiri gem is used to parse xml
      projects = Nokogiri::XML(response.body)
      # we use css to find an element called name inside another called project
      # then we check if the text equals the project name
      projects.css("project name").text.should eql(project.name)
    end   
  end
  
  context "creating a project" do
    let(:url) {"/api/v1/projects"}
    
    before do
      user.admin = true
      user.save!
    end
    
    it "successful json" do
      post "#{url}.json", :token => token, :project => { :name => "Inspector" }
      project = Project.find_by_name("Inspector")
      route = "/api/v1/projects/#{project.id}"
      
      response.status.should eql(201)
      response.headers["Location"].should eql(route)
      response.body.should eql(project.to_json)
    end
    
    it "unsuccessful json" do
      post "#{url}.json", :token => token, :project => { :name => "" }
      response.status.should eql(422)
      errors = {"errors" => {"name" => ["can't be blank"]}}.to_json
      response.body.should eql(errors)
    end
  end
  
  context "showing a project with last ticket" do
    let!(:project) { FactoryGirl.create(:project) }
    let!(:ticket) { FactoryGirl.create(:ticket, project: project) }
    let(:url) {"/api/v1/projects/#{project.id}"}  
    
    it "json" do
      get "#{url}.json", :token => token
      # the last_ticket method is defined on a project object
      project_json = project.to_json(:methods => "last_ticket")
      response.body.should eql(project_json)
      response.status.should eql(200)
      
      project_response = JSON.parse(response.body)
      ticket_title = project_response["last_ticket"]["title"]
      ticket_title.should_not be_blank 
    end 
  end
  
  context "updating a project" do
    let(:url) { "/api/v1/projects/#{project.id}"}
    before do
      user.admin = true
      user.save!
    end
    
    it "successful json" do
      put "#{url}.json", :token => token, :project => { name: "Not ticketee" }
      
      response.status.should eql(204)
      response.body.should eql("")
      
      project.reload
      project.name.should eql("Not ticketee")   
    end
    
    it "unsuccessful json" do
      put "#{url}.json", :token => token, :project => { name: "" }
      
      response.status.should eql(422)
      errors = { :errors => {:name => ["can't be blank"]}}
      response.body.should eql(errors.to_json)
    end   
  end
  
  context "deleting a project" do
    let(:url) { "/api/v1/projects/#{project.id}"}
    before do
      user.admin = true
      user.save!
    end
    
    it "json" do
      delete "#{url}.json", :token => token
      response.status.should eql(204)
    end
  end
  
end
