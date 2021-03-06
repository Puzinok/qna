class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  after_create :send_notice

  def toggle_best!
    transaction do
      previous_best_answer = question.answers.find_by(best: true)
      previous_best_answer&.update_column(:best, false)
      update_column(:best, true)
    end
  end

  def get_attachments
    attachments.map do |a|
      { filename: a.file.identifier, url: a.file.url }
    end
  end

  private

  def send_notice
    SendNoticeJob.perform_later question
  end
end
