require 'rails_helper'

feature 'User delete own question or answer', %q{
  In order to delete wrong question or answer
  As an authenticate user
  I want to be able to delete own question or answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:valid_question, user: user) }
  given(:another_user) { create(:user) }

  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author can delete the question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete Question'
    expect(page).to have_content('Your question succefully deleted.')
  end

  scenario 'Another user cannot delete question' do
    sign_in(another_user)

    visit question_path(question)
    expect(page).to have_no_link('Delete Question')
  end

  scenario 'Author can delete own answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete Answer'
    expect(page).to have_content('Your answer succefully deleted.')
  end

  scenario 'Non Author of answer cannot delete answer' do
    sign_in(another_user)

    visit question_path(question)
    expect(page).to have_no_link('Delete Answer')
  end

  scenario 'Non Authenticated user cannot view Delete button' do
    visit question_path(question)
    expect(page).to have_no_link('Delete Answer')
  end
end
