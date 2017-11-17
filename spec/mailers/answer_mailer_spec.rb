require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe 'send_notice_author' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, user: author) }
    let(:mail) { AnswerMailer.send_to(author, question) }

    it "renders the headers" do
      expect(mail.subject).to match("New answer for your question.")
      expect(mail.to).to eq([author.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello")
    end
  end
end
