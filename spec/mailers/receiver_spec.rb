require "spec_helper"

describe Receiver do
  context "reply to a comment" do
    let!(:project) {FactoryGirl.create(:project)}
    let!(:ticket_owner) {FactoryGirl.create(:user, email: "jfigueroagama@gmail.com")}
    let!(:ticket) {FactoryGirl.create(:ticket, user: ticket_owner, project: project)}
    let!(:commenter) {FactoryGirl.create(:user)}
    let(:comment) do
      Comment.new(
        ticket: ticket,
        user: commenter,
        text: "Test comment")
    end
    
    it "parses the received email to set up the reply" do
      original = Notifier.comment_update(comment, ticket_owner)
      reply_text = "This is a brand new comment"
      reply = Mail.new(:from => "user@example.com",
                       :subject => "Re: #{original.subject}",
                       :body => %Q{#{reply_text} #{original.body}},
                       :to => original.reply_to)
      lambda { Receiver.parse(reply) }.should(change(ticket.comments, :count).by(1))
      ticket.comments.last.text.should eql(reply_text)
    end
  end
end
