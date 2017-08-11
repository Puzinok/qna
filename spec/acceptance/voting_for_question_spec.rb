require_relative 'acceptance_helper'

feature 'User can voting for question', %q{
  'In order to increase or decrease the question rating'
  'As an authenticate user'
  'I would like to be voting question'
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  scenario 'Non authenticate user doesnt see voting links' do
    visit question_path(question)

    expect(page).to_not have_selector('.glyphicon-plus')
  end

  context 'Authenticate user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can voting for question', js: true do
      within '.rating' do
        find('.glyphicon.glyphicon-plus').trigger('click')
        expect(page).to have_content('1')
      end
    end

    scenario 'can voting against question', js: true do
      within '.rating' do
        find('.glyphicon.glyphicon-minus').trigger('click')
        expect(page).to have_content('-1')
      end
    end

    scenario 'can reset own vote', js: true do
      within '.rating' do
        find('.glyphicon.glyphicon-plus').click
        expect(page).to have_content('1')

        wait_for_ajax
        find('.glyphicon.glyphicon-repeat').click
        expect(page).to have_content('0')
      end
    end

    scenario 'can vote only once', js: true do
      within '.rating' do
        find('.glyphicon.glyphicon-plus').click
        wait_for_ajax
        expect(page).to have_content('1')

        find('.glyphicon.glyphicon-plus').click
        wait_for_ajax
        expect(page).to have_content('User can vote once!')
      end
    end
  end

  context 'Author' do
    given(:author){ create(:user) }
    given(:author_question){ create(:question, user: author) }

    scenario 'doesnt see voting links' do
      visit question_path(author_question)

      expect(page).to_not have_selector('.rating_controls')
    end
  end


end