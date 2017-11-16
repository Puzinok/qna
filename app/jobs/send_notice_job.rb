class SendNoticeJob < ApplicationJob
  queue_as :default

  def perform(question)
    question.subscriptions.each do |subscription|
      AnswerMailer.send_to(subscription.user, question).deliver_later
    end
  end
end
