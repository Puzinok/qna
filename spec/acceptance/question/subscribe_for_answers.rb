require_relative '../acceptance_helper'

feature 'Subscribe to question', %q{
  In order to follow answers
  As an authenticated user
  I want to be able subscribe to answers of question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  context 'Guest' do
    scenario 'doesnt see subscribe link' do
      visit question_path(question)
      expect(page).to_not have_link('Subscribe')
    end
  end

  context 'Authenticate user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'see subscribe link' do
      expect(page).to have_link('Subscribe')
    end

    scenario 'can subscribe', js: true do
      click_on 'Subscribe'
      expect(page).to have_content("You subscribed!")
    end

    scenario 'cam see unsubscribe link', js: true do
      click_on 'Subscribe'
      visit question_path(question)
      expect(page).to have_content("Unsubscribe")
    end
  end
end
