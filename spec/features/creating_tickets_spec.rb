require 'spec_helper'

feature "Creating Tickets" do
  before do
    project = FactoryGirl.create(:project)
    user = FactoryGirl.create(:user)
    # define_permission! method is defined in the authorization_helpers.rf inside spec/support/
    # it creates a permission record for user, action, project parameters => in the test DB
    # this has to be changed to the permissions model (cancan?)
    define_permission!(user, "view", project)
    define_permission!(user, "create tickets", project)
    define_permission!(user, "tag", project)
    @email = user.email
    sign_in_as!(user)
    
    visit root_path
    click_link project.name
    click_link "New Ticket"
    
    # Because now we are signed in as an user we do not need these lines
    
    #message = "You need to sign in or sign up before continuing."
    #expect(page).to have_content(message)
    
    #fill_in "Name", with: user.name
    #fill_in "Password", with: user.password
    #click_button "Sign in"
    
    #click_link project.name
    #click_link "New Ticket"
  end
  
  scenario "creating a ticket" do
    fill_in "Title", with: "Non-standard compliance"
    fill_in "Description", with: "My pages are ugly!"
    click_button "Create Ticket"
    
    expect(page).to have_content("Ticket has been created.")
    within "#ticket #author" do
      expect(page).to have_content("Created by #{@email}")
    end
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
  
  scenario "creating a ticket with tags" do
    fill_in "Title", with: "Non-standard compliance"
    fill_in "Description", with: "My pages are ugly!"
    fill_in "Tags", with: "browser visual"
    click_button "Create Ticket"
    
    expect(page).to have_content("Ticket has been created.")
    within("#ticket #tags") do
      page.should have_content("browser")
      page.should have_content("visual")
    end
  end
end
