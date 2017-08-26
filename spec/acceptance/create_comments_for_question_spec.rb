require_relative 'acceptance_helper'

feature 'Create comments for question', %q{
  In order to clarify about question
  As an authenticate user
  I want to be able to leave comments'
  } do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:comment) { create(:comment, commentable: question) }

  scenario 'Authenticate user can leave comment', js: true do
    sign_in(user)

    visit question_path(question)

    within '#question' do
      fill_in 'New comment', with: comment.body
      click_on 'Create'
    end

    expect(page).to have_content(comment.body)
  end

  scenario "Non authenticate user can't see comments form" do
    visit question_path(question)

    expect(page).to_not have_content('New comment')
  end

  context 'multiple session' do
    scenario "comment appears to another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '#question' do
          fill_in 'New comment', with: comment.body
          click_on 'Create'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content(comment.body)
      end
    end
  end
end
