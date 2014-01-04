require 'spec_helper'

describe TicketsController do
  # Test in controller are to restrict actions for that controller
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  # A ticket belongs to a user and belongs to a project
  let(:ticket) { FactoryGirl.create(:ticket, project: project, user: user) }
  
  context "Standard users" do
    
    it "cannot access a ticket in a project that does not have permission" do
      sign_in(user)
      # View a ticket that belongs to a project
      get :show, :id => ticket.id, :project_id => project.id
      
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eql("The project you were looking for could not be found.")
    end
    
    context "with permission to view the project" do
      before do
        sign_in(user)
        define_permission!(user, "view", project)
      end
      
      def cannot_create_tickets!
        response.should redirect_to(project)
        message = "You cannot create tickets on this project."
        flash[:alert].should eql(message)
      end
      
      def cannot_update_tickets!
        expect(response).to redirect_to(project)
        expect(flash[:alert]).to eql("You cannot edit tickets on this project.")
      end
      
      it "cannot begin to create a ticket" do
        get :new, :project_id => project.id
        cannot_create_tickets!
      end
      
      it "cannot create a ticket without permission" do
        post :create, :project_id => project.id
        cannot_create_tickets!
      end
      
      it"cannot edit a ticket without permission" do
        get :edit, { project_id: project.id, id: ticket.id }
        cannot_update_tickets!
      end
      
      it"cannot update a ticket without pwrmission" do
        # We pass a project_id so set_project can find the project
        # We pass the id so set_ticket can find the ticket
        # We pass {} so params[:ticket] is set => empty
        put :update, { project_id: project, id: ticket.id, ticket: {} }
        cannot_update_tickets!
      end
      
      it"cannot delete a ticket without permission" do
        delete :destroy, { project_id: project.id, id: ticket.id }
        
        expect(response).to redirect_to(project)
        message = "You cannot delete tickets on this project."
        expect(flash[:alert]).to eql(message)
      end
    end
    
  end
end
