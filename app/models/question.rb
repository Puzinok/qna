class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  private
  
  def self.of_past_day
    where(created_at: Date.yesterday.beginning_of_day..Time.now)
  end
end
