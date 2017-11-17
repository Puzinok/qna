ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body
  indexes user.email, as: :author, sortable: true

  has user_id, commentable_id, commentable_type, created_at, updated_at
end