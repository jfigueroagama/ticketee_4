require 'spec_helper'

feature "Real email with gmail" do
  let!(:alice) { FactoryGirl.create(:user) }
  let!(:me) { FactoryGirl.create(:user, email: "jfigueroagama@gmail.com") }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:state_before) { FactoryGirl.create(:state, name: "Open") }
  let!(:ticket) { FactoryGirl.create(:ticket, user: me, project: project) }
  
  before do
    ActionMailer::Base.delivery_method = :smtp
    define_permission!(alice, "view", project)
    define_permission!(alice, "change states", project)
    define_permission!(me, "view", project)
  end
  
  after do
    ActionMailer::Base.delivery_method = :test
  end
  
  scenario "receiving a real world email" do
    sign_in_as!(alice)
    visit project_ticket_path(project, ticket)
    fill_in "Text", with: "Posting a comment"
    select "Open", from: "State"
    click_button "Create Comment"
    
    expect(page).to have_content("Comment has been created.")
    ticketee_emails.should be_present
    email = ticketee_emails.first
    subject = "[ticketee] #{project.name} - #{ticket.title}"
    email.subject.should eql(subject)
    # We are getting a [Gmail/trash] error
    #clear_ticketee_emails!
  end
  
end
