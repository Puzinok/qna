module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def rating
    votes.sum(:value)
  end

  def voted?(user)
    votes.find_by(user: user)
  end

  def voting(user, value)
    return if user.author_of?(self)
    return if voted?(user)
    vote = votes.build(user: user, value: value)
    vote.save
  end

  def vote_destroy(user)
    vote = voted?(user)
    vote.destroy if vote
  end
end
