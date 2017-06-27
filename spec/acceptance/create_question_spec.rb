require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an Authenticated User
  I want to be able create a question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated User can create the question' do
    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Create'

    expect(page).to have_content('Your question succefully created.')
  end

  scenario "Non Authenticated User can't create question" do
    visit new_question_path
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario 'Try create invalid question' do
    sign_in(user)

    visit new_question_path
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'
    expect(page).to have_content('Errors:')
  end
end