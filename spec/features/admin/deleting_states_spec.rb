require 'spec_helper'

feature "Deleting States" do
  let!(:admin) { FactoryGirl.create(:admin_user) }
  
  before do
    load Rails.root + "db/seeds.rb"
    sign_in_as!(admin)
    visit root_path
    
    click_link "Admin"
    click_link "States"
  end
  
  scenario "deleting a state" do
    
    within state_line_for("Open") do
      click_link "Delete state"
    end
    
    expect(page).to have_content("State has been deleted.")
  end
end
