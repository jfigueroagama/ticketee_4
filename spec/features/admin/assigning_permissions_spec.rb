require 'spec_helper'

feature "Assigning Permissions" do
  let!(:admin) { FactoryGirl.create(:admin_user) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket, project: project, user: user) }
  
  before do
    sign_in_as!(admin) 
    click_link "Admin"
    click_link "Users"
    # We use let!(:user) otherwise we will not see user.email in the test DB
    click_link user.email
    click_link "Permissions"
  end
  
  scenario "Viewing a project" do
    check_permission_box "view", project
    click_button "Update"
    click_link "Sign out"
    
    sign_in_as!(user)
    
    expect(page).to have_content(project.name)
  end
  
  scenario "Creating tickets for a project" do
    check_permission_box "view", project
    check_permission_box "create_tickets", project
    click_button "Update"
    click_link "Sign out"
    
    sign_in_as!(user)
    click_link project.name
    click_link "New Ticket"
    fill_in "Title", with: "Shiny!"
    fill_in "Description", with: "Make it so"
    click_button "Create Ticket"
    
    expect(page).to have_content("Ticket has been created.")
  end
  
  scenario "Updating a ticket for a project" do
    check_permission_box "view", project
    check_permission_box "edit_tickets", project
    click_button "Update"
    click_link "Sign out"
    
    sign_in_as!(user)
    click_link project.name
    click_link ticket.title
    click_link "Edit Ticket"
    fill_in "Title", with: "Really shiny!"
    click_button "Update Ticket"
    
    expect(page).to have_content("Ticket has been updated.")
  end
  
  scenario "Deleting a ticket for a project" do
    check_permission_box "view", project
    check_permission_box "delete_tickets", project
    click_button "Update"
    click_link "Sign out"
    
    sign_in_as!(user)
    click_link project.name
    click_link ticket.title
    click_link "Delete Ticket"
    
    expect(page).to have_content("Ticket has been deleted.")
  end
end
