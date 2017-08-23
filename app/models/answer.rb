class Answer < ApplicationRecord
  include Attachable
  include Votable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

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
end
