class Answer < ApplicationRecord
  include Attachable

  belongs_to :question
  belongs_to :user
  has_many :votes, as: :votable

  validates :body, presence: true

  def toggle_best!
    transaction do
      previous_best_answer = question.answers.find_by(best: true)
      previous_best_answer&.update_column(:best, false)
      update_column(:best, true)
    end
  end

  def rating
    votes.sum(:value)
  end

  def voted?(user)
    votes.find_by(user: user)
  end
end
