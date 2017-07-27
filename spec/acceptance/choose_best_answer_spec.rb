require_relative 'acceptance_helper'

feature 'Choose the best answer', %q{
  In order to help other users
  As an author of question
  I want to be able choose the best answer
} do

  given(:question){ create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:user){ create(:user) }

  scenario 'Non authenticade user try choose the best answer' do
    visit question_path(question)
    expect(page).to_not have_link('Best')
  end

  scenario 'Not author try choose the best answer' do

    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link('Best')
  end


  context 'Author of question' do
    given(:author_question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: author_question) }
    given!(:best_answer) { create(:answer, question: author_question, best: true)}

    scenario "see link 'Best'" do
      sign_in(user)

      visit question_path(author_question)
      expect(page).to have_link('Best')
    end

    scenario "try choose only one best answer", js: true do
      sign_in(user)
      visit question_path(author_question)

      within '.answers' do
        click_on('Best')
        expect(page).to have_content('Best answer')
      end
    end

    scenario "try rechoose the best answer", js: true do
      sign_in(user)
      visit question_path(author_question)

      within '.answers' do
        click_on('Best')
        expect(page).to have_content('Best answer')

        click_on('Best')
        expect(page).to have_content('Best answer')
      end
    end
  end
end