require 'spec_helper'

feature "Creating comments" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) } 
  let!(:state_before) { FactoryGirl.create(:state, name: "Open") }
  let!(:state_after) { FactoryGirl.create(:state, name: "New") }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project, user: user, state: state_before) }
  
  before do
    define_permission!(user, "view", project)
    sign_in_as!(user)
    visit root_path
    click_link project.name
  end
  
  scenario "creating a comment" do
    define_permission!(user, "change states", project)
    click_link ticket.title
    fill_in "Text", with: "Added a comment!"
    select "New", from: "State"
    click_button "Create Comment"
    
    expect(page).to have_content("Comment has been created.")
    within("#comments") do
      expect(page).to have_content("Added a comment!")
    end
  end
  
  scenario "creating an invalid comment" do
    define_permission!(user, "change states", project)
    click_link ticket.title
    click_button "Create Comment"
    
    expect(page).to have_content("Comment has not been created.")
  end
  
  scenario "changing ticket's state" do
    define_permission!(user, "change states", project)
    click_link ticket.title
    fill_in "Text", with: "This is a real issue"
    select "Open", from: "State"
    click_button "Create Comment"
    
    expect(page).to have_content("Comment has been created.")
    expect(page).to have_content("Open")
    within("#ticket") do
      ticket.state.name.should eql("Open")
      page.should have_content("Open")
      expect(page).to have_content("Open")
    end
    within("#comments") do
      page.should have_content("State: Open")
      expect(page).to have_content("State: Open")
    end
  end
  
  scenario "A user without permission cannot change state" do
    click_link ticket.title
    # The find method is wrapped in a lambda so RSpec rescue the exception
    find_element = lambda { find("#comment_state_id") }
    message = "Expected not to see #comment_state_id, but did"
    find_element.should(raise_error(Capybara::ElementNotFound), message)
  end
  
end
