require 'spec_helper'

feature "Hidden Links" do
  # The object is created when it is used
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:ticket) { FactoryGirl.create(:ticket, project: project, user: user) }
  
  context "anonymous user" do
    scenario "cannot see New Project link" do
      visit root_path
      assert_no_link_for "New Project"
    end
    
    scenario "cannot see the Edit Project link" do
      visit project_path(project)
      assert_no_link_for "Edit Project"
    end
    
    scenario "cannot see the Delete Project link" do
      visit project_path(project)
      assert_no_link_for "Delete Project"
    end
  end
  
  context "regular users" do
    before { sign_in_as!(user) }
    
    scenario "cannot see New Project link" do
      visit root_path
      assert_no_link_for "New Project"
    end
    
    scenario "cannot see the Edit Project link" do
      visit project_path(project)
      assert_no_link_for "Edit Project"
    end
    
    scenario "cannot see the Delete Project link" do
      visit project_path(project)
      assert_no_link_for "Delete Project"
    end
    
    scenario "New Ticket link is shown to the user with permission" do
      define_permission!(user, "view", project)
      define_permission!(user, "create tickets", project)
      visit project_path(project)
      assert_link_for "New Ticket"
    end
    
    scenario "New Ticket link is hidden from the user without permission" do
      define_permission!(user, "view", project)
      visit project_path(project)
      assert_no_link_for "New Ticket"
    end
    
    scenario "Edit Ticket link is shown to the user with permission" do
      # We need to set a ticket first
      ticket
      define_permission!(user, "view", project)
      define_permission!(user, "edit tickets", project)
      visit project_path(project)
      click_link ticket.title
      assert_link_for "Edit Ticket"    
    end
    
    scenario "Edit Ticket link is hidden from the user without permission" do
      # We need to set a ticket first
      ticket
      define_permission!(user, "view", project)
      visit project_path(project)
      click_link ticket.title
      assert_no_link_for "Edit Ticket"    
    end
    
    scenario "Delete Ticket link is shown to the user with permission" do
      # We need to set a ticket first
      ticket
      define_permission!(user, "view", project)
      define_permission!(user, "delete tickets", project)
      visit project_path(project)
      click_link ticket.title
      assert_link_for "Delete Ticket"    
    end
    
    scenario "Delete Ticket link is hidden from the user without permission" do
      # We need to set a ticket first
      ticket
      define_permission!(user, "view", project)
      visit project_path(project)
      click_link ticket.title
      assert_no_link_for "Delete Ticket"    
    end
  end
  
  context "admin users" do
    before { sign_in_as!(admin) }
    
    scenario "can see New Project link" do
      visit root_path
      assert_link_for "New Project"
    end
    
    scenario "can see the Edit Project link" do
      visit project_path(project)
      assert_link_for "Edit Project"
    end
    
    scenario "can see the Delete Project link" do
      visit project_path(project)
      assert_link_for "Delete Project"
    end
    
    scenario "New Ticket link is shown to admins" do
      visit project_path(project)
      assert_link_for "New Ticket"
    end
    
    scenario "Edit Ticket link is shown to admins" do
      ticket
      visit project_path(project)
      click_link ticket.title
      assert_link_for "Edit Ticket"
    end
    
    scenario "Delete Ticket link is shown to admins" do
      ticket
      visit project_path(project)
      click_link ticket.title
      assert_link_for "Delete Ticket"
    end
  end
end
