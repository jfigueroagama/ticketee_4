require 'spec_helper'

feature "Seed Data" do
  let!(:user) { FactoryGirl.create(:user, email: "admin@example.com", password: "password", admin: true) }
  
  scenario "the basics" do
    #load Rails.root + "db/seeds.rb" # This is the code run by: rae db:seed
    # remember where returns a relation object...
    #user = User.where(email: "admin@example.com").first!
    #project = Project.where(name: "Ticketee Beta").first!
  end
  
  scenario "the states" do
    load Rails.root + "db/seeds.rb"
    project = Project.find_by_name("Ticketee Beta")
    sign_in_as!(user)
    click_link "Ticketee Beta"
    click_link "New Ticket"
    fill_in "Title", with: "Comment with state"
    fill_in "Description", with: "Comments always have a state."
    click_button "Create Ticket"
    within("#comment_state_id") do
      expect(page).to have_content("Open")
      expect(page).to have_content("New")
      expect(page).to have_content("Closed")
    end
  end
end
