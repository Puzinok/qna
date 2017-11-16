require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe 'send_notice_author' do 
    let!(:author) { create(:user) }
    let!(:question) { create(:question, user: author) }
    let(:mail) { AnswerMailer.send_to(author, question) }
    
    it "renders the headers" do
      mail.subject.should eq("New answer for your question.")
      mail.to.should eq([author.email])
      mail.from.should eq(["noreply@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hello")
    end
  end
end
