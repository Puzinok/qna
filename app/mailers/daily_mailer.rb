class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.of_past_day
    mail(to: user.email, subject:  "Digest [#{Date.yesterday}]")
  end
end
