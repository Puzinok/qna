# Preview all emails at http://localhost:3000/rails/mailers/daily_mailer
class DailyMailerPreview < ActionMailer::Preview
  def daily
    DailyMailer.digest(User.first)
  end
end
