class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |attributes| attributes['file'].nil? }

  def toggle_best!
    transaction do
      previous_best_answer = question.answers.find_by(best: true)
      previous_best_answer&.update_column(:best, false)
      self.update_column(:best, true)
    end
  end
end
