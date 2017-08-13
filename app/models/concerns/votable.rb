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
end
