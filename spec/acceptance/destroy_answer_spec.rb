require_relative 'acceptance_helper'

feature 'User delete own answer', %q{
  In order to delete wrong answer
  As an authenticate user
  I want to be able to delete own answer
} do
  given(:answer) { create(:answer) }

  context 'Authenticated user' do
    given(:user) { create(:user) }
    given(:user_answer) { create(:answer, user: user) }

    scenario 'Author can delete answer', js: true do
      sign_in(user)

      visit question_path(user_answer.question)
      click_on 'Delete Answer'
      expect(current_path).to eq question_path(user_answer.question)

      within '.answers' do
        expect(page).to have_no_content(user_answer.body)
      end
    end

    scenario 'Non Author of answer cannot delete answer' do
      sign_in(user)

      visit question_path(answer.question)
      expect(page).to have_no_link('Delete Answer')
    end
  end

  context 'Non authenticated user' do
    scenario 'doesnt delete answer' do
      visit question_path(answer.question)
      expect(page).to have_no_link('Delete Answer')
    end
  end
end
