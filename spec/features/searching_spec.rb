require 'spec_helper'

feature "Searching" do
  
  let!(:user) {FactoryGirl.create(:user)} 
  let!(:project) {FactoryGirl.create(:project)}
  let!(:state_open) {FactoryGirl.create(:state, name: "Open")}
  let!(:state_closed) {FactoryGirl.create(:state, name: "Closed")}
  let!(:ticket_1) {FactoryGirl.create(:ticket, title: "Create projects", user: user, project: project, state: state_open, tag_names: "iteration_1")}
  let!(:ticket_2) {FactoryGirl.create(:ticket, title: "Create users", user: user, project: project, state: state_closed, tag_names: "iteration_2")}
  
  before do
    define_permission!(user, "view", project)
    define_permission!(user, "tag", project)
    sign_in_as!(user)
    visit root_path
    click_link project.name
  end
  
  scenario "Finding by tag" do
    fill_in "Search", with: "tag:iteration_1"
    click_button "Search"
    
    within("#tickets") do
      page.should have_content("Create projects")
      page.should_not have_content("Create users")
    end
  end
  
  scenario "Finding by tstate" do
    fill_in "Search", with: "state:Open"
    click_button "Search"
    
    within("#tickets") do
      page.should have_content("Create projects")
      page.should_not have_content("Create users")
    end
  end
  
  scenario "Clicking a tag goes to search results" do
    click_link "Create projects"
    click_link "iteration_1"
    
    within("#tickets") do
      page.should have_content("Create projects")
      page.should_not have_content("Create users")
    end
  end
   
end
