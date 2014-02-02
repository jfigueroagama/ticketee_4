require 'spec_helper'

describe "/api/v1/tickets", :type => :api do
  let!(:project) { FactoryGirl.create(:project, name: "Ticketee") }
  let!(:user) { FactoryGirl.create(:user) }
  let(:token) { user.access_token }
  
  before do
    user.permissions.create!(:action => "view", :thing => project)
  end
  
  context "index" do
    before do
      5.times do
        FactoryGirl.create(:ticket, project: project, user: user)
      end
    end
    
    let(:url) { "/api/v1/projects/#{project.id}/tickets" }
    
    it "JSON" do
      get "#{url}.json", :token => token
      response.body.should eql(project.tickets.to_json)
    end
    
    it "XML" do
      get "#{url}.xml", :token => token
      response.body.should eql(project.tickets.to_xml)
    end
  end
end
