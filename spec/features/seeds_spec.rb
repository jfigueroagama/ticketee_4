require 'spec_helper'

feature "Seed Data" do
  
  scenario "the basics" do
    load Rails.root + "db/seeds.rb" # This is the code run by: rae db:seed
    # remember where returns a relation object...
    user = User.where(email: "admin@example.com").first!
    project = Project.where(name: "Ticketee Beta").first!
  end
end
