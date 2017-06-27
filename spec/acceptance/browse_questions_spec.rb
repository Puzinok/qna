require 'rails_helper'

feature 'Browse all questions', %q{
  In order to find question or answer
  As an user
  I want to be able browse all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:valid_question, 3, user: user ) }

  scenario 'User can browse all questions' do
    visit questions_path
    expect(page).to have_content(questions.first.title)
    expect(page).to have_content(questions.first.body)
  end

  scenario 'Authenticated user browse all questions' do
    visit questions_path
    expect(page).to have_content(questions.first.title)
    expect(page).to have_content(questions.first.body)
  end
end
