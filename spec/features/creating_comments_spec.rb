require 'spec_helper'

feature "Creating comments" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) } 
  let!(:state) { FactoryGirl.create(:state, name: "Open") }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project, user: user, state: state) }
  
  before do
    define_permission!(user, "view", project)
    sign_in_as!(user)
    visit root_path
    click_link project.name
  end
  
  scenario "creating a comment" do
    click_link ticket.title
    fill_in "Text", with: "Added a comment!"
    click_button "Create Comment"
    
    expect(page).to have_content("Comment has been created.")
    within("#comments") do
      expect(page).to have_content("Added a comment!")
    end
  end
  
  scenario "creating an invalid comment" do
    click_link ticket.title
    click_button "Create Comment"
    
    expect(page).to have_content("Comment has not been created.")
  end
  
  scenario "changing ticket's state" do
    click_link ticket.title
    fill_in "Text", with: "This is a real issue"
    select "Open", from: "State"
    click_button "Create Comment"
    
    expect(page).to have_content("Comment has been created.")
    expect(page).to have_content("Open")
    within("#ticket") do
      ticket.state.name.should eql("Open")
      page.should have_content("Open")
    end
    within("#comments") do
      page.should have_content("State: Open")
    end
  end
  
end
