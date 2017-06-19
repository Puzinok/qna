require 'rails_helper'

feature 'Singin in', %q{
  In order to authenticate
  As an User
  I want be able to sign in
} do

  scenario 'Existing User try to sign in' do
    User.create!(email: 'user@example.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@exmaple.com'
    fill_in 'Password', with: '12345678'
    click_on 'Sign in'

    expect(page).to have_content 'Signed in successfully.'
  end
end

