class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, optional: true

  validates :value, inclusion: -1..1
  validates_uniqueness_of :user_id, scope: :votable_id, message: 'can vote once!'
end
