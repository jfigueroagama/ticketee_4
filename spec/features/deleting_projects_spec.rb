require 'spec_helper'

feature "Deleting Projects" do
  scenario "deleting a project" do
    FactoryGirl.create(:project, name: "TextMate 2")
    visit root_path
    click_link "TextMate 2"
    click_link "Delete Project"
    
    expect(page).to have_content("Project has been deleted.")
    
    visit root_path
    
    expect(page).to have_no_content("TextMate 2")
  end
end
