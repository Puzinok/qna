require_relative 'acceptance_helper'

feature 'Create comments for question', %q{
  In order to clarify about question
  As an authenticate user
  I want to be able to leave comments'
  } do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:comment) { create(:comment, commentable: question) }

  scenario 'Authenticate user can leave comment' do
    sign_in(user)

    visit question_path(question)

    within '#question_comments' do
      fill_in 'New comment', with: comment.body
      click_on 'Create'
    end
  end

  scenario "Non authenticate user can't leave comment"
  scenario 'Non authenticate user can see commen'

  context 'multiple session' do
    scenario "comment appears to another user's page"
  end
end
