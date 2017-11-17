ThinkingSphinx::Index.define :user, with: :active_record do
  indexes user.email, as: :author, sortable: true

  has admin, created_at, updated_at
end