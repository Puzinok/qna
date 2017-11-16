class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  after_create :subscribe_author
  
  private

  def subscribe_author
    subscriptions.create!(user: user)
  end

  def self.of_past_day
    where(created_at: Date.yesterday.beginning_of_day..Time.now)
  end
end
