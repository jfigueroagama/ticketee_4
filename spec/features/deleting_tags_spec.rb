require 'spec_helper'

feature "Deleting tags" do
  
  let!(:user) {FactoryGirl.create(:user)} 
  let!(:project) {FactoryGirl.create(:project)}
  let!(:ticket) {FactoryGirl.create(:ticket, user: user, project: project, tag_names: "this-tag-must-die")}
  
  before do
    sign_in_as!(user)
    define_permission!(user, "view", project)
    define_permission!(user, "tag", project)
    
    visit root_path
    click_link project.name
    click_link ticket.title
  end
  # js: true allows to use capybara and rspec with JavaScript
  scenario "deleting a tag", js: true do
    click_link "delete-this-tag-must-die"
    within("#ticket #tags") do
      page.should_not have_content("this-tag-must-die")
    end
  end
end
