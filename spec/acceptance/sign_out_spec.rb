require 'rails_helper'

feature 'Singin out', %q{
  In order to log out
  As a registered user
  I want to be able sign out
} do

  scenario 'Registered user try to sign out' do
    User.create!(email: 'user@example.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit root_path
    save_and_open_page
    click_on 'Log out'

    expect(page).to have_content('Signed out successfully.')
  end
end