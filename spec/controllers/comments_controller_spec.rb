require 'spec_helper'

describe CommentsController do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:state) { FactoryGirl.create(:state) }
  let(:ticket) { FactoryGirl.create(:ticket, user: user, project: project) }
  
  context "A user without permission to set a state" do
    before do
      sign_in(user)
    end
    
    it "cannot transition a state by passing state__id" do
      post :create, { comment: {text: "hacked!", state_id: state.id}, ticket_id: ticket.id }
      # Since create action created a new comment, we use reload to fetch
      # the ticket again from the DB and update the object's attributes
      ticket.reload
      
      ticket.state.should eql(nil) 
    end
  end

end
