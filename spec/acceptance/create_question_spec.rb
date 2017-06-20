require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an Authenticated User
  I want to be able create a question
} do

  scenario 'Authenticated User can create the question' do
    User.create!(email: 'user@example.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit new_question_path
    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test Question'
    click_on 'Create'

    expect(page).to have_content('Your question succefully created.')
  end

  scenario "Non Authenticated User can't create question" do
    visit new_question_path
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end