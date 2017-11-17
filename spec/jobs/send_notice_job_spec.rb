require 'rails_helper'

RSpec.describe SendNoticeJob, type: :job do
  let(:question)      { create(:question) }
  let(:answer)        { create(:answer, question: question) }
  let(:subscriptions) { create_list(:subscription, 2, question: question, user: question.user) }

  it 'calls AnswerMailer for send notification' do
    subscriptions.each do |subscription|
      expect(AnswerMailer)
        .to receive(:send_to)
        .with(subscription.user, question).and_call_original
    end

    expect(AnswerMailer).to receive(:send_to).with(question.user, question).and_call_original

    SendNoticeJob.perform_now(question)
  end
end
