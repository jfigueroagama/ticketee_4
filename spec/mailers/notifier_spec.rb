require "spec_helper"

describe Notifier do
  context "comment_update" do
    let!(:project) {FactoryGirl.create(:project)}
    let!(:ticket_owner) {FactoryGirl.create(:user)}
    let!(:ticket) {FactoryGirl.create(:ticket, user: ticket_owner, project: project)}
    let!(:commenter) {FactoryGirl.create(:user)}
    let(:comment) do
      Comment.new(
        ticket: ticket,
        user: commenter,
        text: "Test comment")
    end
    let(:email) do
      Notifier.comment_update(comment, ticket_owner)
    end
    
    it "sends an email notification about the new comment" do
      email.to.should include(ticket_owner.email)
      title = "#{ticket.title} for #{project.name} has been updated:"
      email.body.should include(title)
      email.body.should include("#{comment.user.email} wrote:")
      email.body.should include(comment.text)
    end
    
    it "correctly sets Reply-To" do
      # We add the project.id and ticket.id to know to whom reply
      address = "jfigueroagama+#{project.id}+#{ticket.id}@gmail.com"
      email.reply_to.should == [address]
    end
  end
end
