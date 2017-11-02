module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def voted?(user)
    votes.find_by(user: user)
  end

  def vote(user, value)
    return if voted?(user)
    votes.create(user: user, value: value)
  end

  def vote_destroy(user)
    vote = voted?(user)
    vote&.destroy
  end
end
