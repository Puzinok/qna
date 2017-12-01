class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  default_scope { order(created_at: 'ASC') }
end
