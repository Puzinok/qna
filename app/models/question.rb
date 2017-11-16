class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  scope :of_past_day, -> { where(created_at: Date.yesterday.beginning_of_day..Time.now) }

  after_create :subscribe_author

  private

  def subscribe_author
    subscriptions.create!(user: user)
  end
end
