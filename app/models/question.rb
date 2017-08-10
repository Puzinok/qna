class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable
  belongs_to :user


  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attributes| attributes['file'].nil? },
                                allow_destroy: true

  def rating
    votes.sum(:value)
  end

  def voted?(user)
    votes.find_by(user: user)
  end
end
