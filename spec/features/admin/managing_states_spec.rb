require 'spec_helper'

feature "managing States" do
  let!(:admin) { FactoryGirl.create(:admin_user) }
  
  before do
    load Rails.root + "db/seeds.rb"
    sign_in_as!(admin)
    
    visit root_path
    click_link "Admin"
    click_link "States"
  end
  
  scenario "marking a state as default" do
  
    within state_line_for("New") do
      click_link "Make default"
    end
    
    page.should have_content("New is now the default state.")
  end
  
end
