class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable
  belongs_to :user


  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attributes| attributes['file'].nil? },
                                allow_destroy: true
end
