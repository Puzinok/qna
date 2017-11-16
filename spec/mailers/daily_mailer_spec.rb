require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let!(:user) { create(:user) }
    let(:mail) { DailyMailer.digest(user) }
    let!(:question) { create(:question) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest [#{Date.yesterday}]")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello")
      expect(mail.body.encoded).to match(question.title)
    end
  end
end
