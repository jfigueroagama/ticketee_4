require 'spec_helper'

feature "Sign in" do
  scenario "signing in via form" do
    user = FactoryGirl.create(:user)
    visit root_path
    click_link "Sign in"
    
    fill_in "Name", with: user.name
    fill_in "Password", with: user.password
    click_button "Sign in"
    
    expect(page).to have_content("Signed in successfully.")  
  end  
end
