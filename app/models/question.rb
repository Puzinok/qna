class Question < ApplicationRecord
  include Attachable

  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable
  belongs_to :user

  validates :title, :body, presence: true

  def rating
    votes.sum(:value)
  end

  def voted?(user)
    votes.find_by(user: user)
  end
end
