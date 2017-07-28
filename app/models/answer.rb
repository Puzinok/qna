class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def toggle_best!
    transaction do
      previous_best_answer = question.answers.find_by(best: true)
      previous_best_answer&.update_column(:best, false)
      self.update_column(:best, true)
    end
  end
end
