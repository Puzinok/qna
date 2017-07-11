require_relative 'acceptance_helper'

feature 'Singin out', %q{
  In order to log out
  As a registered user
  I want to be able sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    sign_in(user)

    visit root_path
    click_on 'Log out'

    expect(page).to have_content('Signed out successfully.')
    expect(page).to have_link('Sign in')
  end

  scenario 'Unregistered user try to sign out' do
    visit root_path

    expect(page).to have_no_link('Log out')
  end
end
