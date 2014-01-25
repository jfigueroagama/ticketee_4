require 'spec_helper'

#include EmailSpec::Helpers
#include EmailSpec::Matchers

feature "Ticket Notifications" do
  
  let!(:alice) {FactoryGirl.create(:user, email: "alice@example.com")}
  let!(:bob) {FactoryGirl.create(:user, email: "bob@example.con")}
  let!(:project) {FactoryGirl.create(:project)}
  let!(:state_before) {FactoryGirl.create(:state, name: "Open")}
  let!(:sate_after) {FactoryGirl.create(:state, name: "New")}
  # This calls the create action in the tickets controller
  let!(:ticket) {FactoryGirl.create(:ticket, user: alice, project: project, state: state_before)}
  
  before do
    # We clear previous email deliveries
    ActionMailer::Base.deliveries.clear
    define_permission!(alice, "view", project)
    define_permission!(alice, "change states", project)
    define_permission!(bob, "view", project)
    define_permission!(bob, "change states", project)
    sign_in_as!(bob)
    visit root_path
    click_link project.name
    click_link ticket.title
    fill_in "Text", with: "Is it out yet?"
    select "New", from: "State"
    click_button "Create Comment"
  end
  
  scenario "Ticket owner receives notifications about comments" do 
    # find_email is a method provided by email_spec gem
    email = find_email!(alice.email)
    subject = "[ticketee] #{project.name} - #{ticket.title}"
    email.subject.should include(subject)
    # click_first_link_in_email is a method provided by email_spec gem
    click_first_link_in_email(email)
    within("#ticket h2") do
      page.should have_content(ticket.title)
    end   
  end
  
  scenario "Comment authors are automatically subscribed to the ticket watchers list" do
    expect(page).to  have_content("Comment has been created.")
    
    find_email!(alice.email)
    click_link "Sign out"
    
    # Clears the email queue
    reset_mailer
    
    sign_in_as!(alice)
    click_link project.name
    click_link ticket.title
    fill_in "Text", with: "Not yet!"
    click_button "Create Comment"
    
    expect(page).to have_content("Comment has been created.")
    find_email!(bob.email)
    lambda { find_email!(alice.email).should raise_error }
  end
  
end
