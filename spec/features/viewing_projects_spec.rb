require 'spec_helper'

feature "Viewing projects" do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:hidden) { FactoryGirl.create(:project, name: "Hidden") }
  
  before do
    sign_in_as!(user)
    define_permission!(user, :view, project)
  end
  
  scenario "Cannot see projects does not have permissions" do
    visit root_path
    
    expect(page).to_not have_content("Hidden")
  end
  
  scenario "Listing all projects" do
    visit root_path
    click_link project.name
    
    expect(page.current_url).to eql(project_url(project)) # project_path(project)
  end
  
end
