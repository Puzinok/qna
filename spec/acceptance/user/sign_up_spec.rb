require_relative '../acceptance_helper'

feature 'Signing up', %q{
  In order to be able sign in
  As an User
  I want to be able registrate
} do

  scenario 'New user try to siging up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test1@example.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end
