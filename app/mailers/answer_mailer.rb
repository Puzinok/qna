class AnswerMailer < ApplicationMailer
  def send_to(user, question)
    @question = question
    mail(to: user.email, subject: "New answer for your question.")
  end
end
