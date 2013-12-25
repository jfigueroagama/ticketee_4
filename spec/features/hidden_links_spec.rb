require 'spec_helper'

feature "Hidden Links" do
  # The object is created when it is used
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:project) { FactoryGirl.create(:project) }
  
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
  end
end
