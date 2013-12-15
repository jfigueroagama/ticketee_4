require 'spec_helper'

feature "Deleting Tickets" do
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project) }
  
  before do
    visit root_path
    click_link project.name
    click_link ticket.title
  end
  
  scenario "delete a ticket" do
    click_link "Delete Ticket"
    
    expect(page).to have_content("Ticket has been deleted.")
    expect(page.current_url).to eq(project_url(project))
  end
end
