require_relative 'acceptance_helper'

feature 'User can voting for answer', %q{
  'In order to increase or decrease the answer rating'
  'As an authenticate user'
  'I would like to be voting answer'
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Non authenticate user doesnt see voting links' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_selector('.glyphicon-plus')
    end
  end

  context 'Authenticate user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can voting for answer', js: true do
      within '.answer_rating' do
        find('.vote_for_answer').trigger('click')
        expect(page).to have_content('1')
      end
    end

    scenario 'can voting against answer', js: true do

      within '.answer_rating' do
        find('.vote_against_answer').trigger('click')
        expect(page).to have_content('-1')
      end
    end

    scenario 'can reset own vote', js: true do
      within '.answer_rating' do
        find('.vote_against_answer').click
        expect(page).to have_content('1')

        find('.vote_reset_answer').click
        expect(page).to have_content('0')
      end
    end

    scenario 'can vote only once', js: true do
      within '.answer_rating' do
        find('.vote_for_answer').click
        wait_for_ajax
        expect(page).to have_content('1')

        find('.vote_for_answer').click
        wait_for_ajax
        expect(page).to have_content('User can vote once!')
      end
    end
  end

  context 'Author' do
    given(:author){ create(:user) }
    given(:author_answer){ create(:answer, user: author, question: question) }

    scenario 'doesnt see voting links' do
      visit question_path(question)

      within '.answer_rating' do
        expect(page).to_not have_selector('.rating_controls')
      end
    end
  end

end