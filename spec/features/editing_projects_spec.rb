require 'spec_helper'

feature "Editing Projects" do
  before do
    # signed in as an admin user
    sign_in_as!(FactoryGirl.create(:admin_user))
    FactoryGirl.create(:project, name: "TextMate 2")
    
    visit root_path
    click_link "TextMate 2"
    click_link "Edit Project"
  end
  
  scenario "updating a project" do  
    fill_in "Name", with: "TextMate 2 beta"
    click_button "Update Project"
    
    expect(page).to have_content("Project has been updated")
  end
  
  scenario "updating projects with no name should retuen an error" do
    fill_in "Name", with: ""
    click_button "Update Project"
    
    expect(page).to have_content("Project has not been updated.")
  end
end
