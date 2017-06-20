require 'rails_helper'

feature 'Singin in', %q{
  In order to be able ask question and answer the questions
  As an User
  I want be able to sign in
} do

  scenario 'Existing User try to sign in' do
    User.create!(email: 'user@example.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content('Signed in successfully.')
  end
end

