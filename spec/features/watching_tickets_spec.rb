require 'spec_helper'

feature "Watching tickets" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, user: user, project: project) }
  
  before do
    define_permission!(user, "view", project)
    sign_in_as!(user)
    visit root_path  
  end
  
  scenario "ticket watch toggling" do
    click_link project.name
    click_link ticket.title
    within("#watchers") do
      page.should have_content(user.email)
    end
    
    click_button "Stop watching this ticket"
    page.should have_content("You are no longer watching this ticket.")
    within("#watchers") do
      page.should_not have_content(user.email)
    end
    
    click_button "Watch this ticket"
    page.should have_content("You are now watching this ticket.")
    within("#watchers") do
      page.should have_content(user.email)
    end
  end
end
