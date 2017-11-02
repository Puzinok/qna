require_relative '../acceptance_helper'

feature 'User delete own question', %q{
  In order to delete wrong question
  As an authenticate user
  I want to be able to delete own question
} do

  given(:question) { create(:question) }

  context 'Authenticated user' do
    given(:user) { create(:user) }
    given(:user_question) { create(:question, user: user) }

    scenario 'Author can delete question' do
      sign_in(user)

      visit question_path(user_question)
      click_on('Delete Question')
      expect(page).to have_no_content(user_question.title)
      expect(page).to have_no_content(user_question.body)
    end

    scenario 'Non author try delete question' do
      sign_in(user)

      visit question_path(question)
      expect(page).to have_no_link('Delete Question')
    end
  end

  context 'Non autherticated user' do
    scenario 'doesnt delete question' do
      visit question_path(question)
      expect(page).to have_no_link('Delete Question')
    end
  end
end
