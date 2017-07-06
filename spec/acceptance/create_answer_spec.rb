require 'rails_helper'

feature 'Create answer the question', %q{
  In order to help other users
  As an authenticate user
  I want to be able to answer the question
  } do

  given(:answer) { create(:answer) }
  given(:question) { create(:question) }

  context 'Authenticated user' do
    given(:user) { create(:user) }
    background { sign_in(user) }

    scenario "can answer the question", js: true do
      visit question_path(question)
      fill_in 'Answer', with: answer.body
      click_on 'Create'
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content(answer.body)
      end
    end

    scenario "cannot create invalid answer", js: true, skip: true do
      visit question_path(question)
      fill_in 'Answer', with: ''
      click_on 'Create'
      expect(page).to have_content("Body can't be blank")
    end
  end

  scenario "Non authenticated user cannot answer the question" do
    visit question_path(question)
    fill_in 'Answer', with: answer.body
    click_on 'Create'
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
