require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let!(:user) { create(:user) } 
    let(:mail) { DailyMailer.digest(user) }
    let!(:question) { create(:question) }

    it "renders the headers" do
      mail.subject.should eq("Digest [#{Date.yesterday}]")
      mail.to.should eq([user.email])
      mail.from.should eq(["noreply@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hello")
      mail.body.encoded.should match(question.title)
    end
  end
end
