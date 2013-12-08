require 'spec_helper'

feature "Creating Tickets" do
  before do
    FactoryGirl.create(:project, name: "Internet Explorer")
    
    visit root_path
    click_link "Internet Explorer"
    click_link "New Ticket"
  end
  
  scenario "creating a ticket" do
    fill_in "Title", with: "Non-standard compliance"
    fill_in "Description", with: "My pages are ugly!"
    click_button "Create Ticket"
    
    expect(page).to have_content("Ticket has been created.")
  end
  scenario "creating a ticked with invalid attributes should raise and error" do
    click_button "Create Ticket"
    
    expect(page).to have_content("Ticket has not been created.")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
  end
  
  scenario "description should be longer that 10 characters" do
    fill_in "Title", with: "Non-standard compliance"
    fill_in "Description", with: "It sucks"
    click_button "Create Ticket"
    
    expect(page).to have_content("Ticket has not been created.")
    expect(page).to have_content("Description is too short")
  end
end
