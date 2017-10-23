require_relative 'acceptance_helper'
require 'capybara/email/rspec'

feature 'Singin in', %q{
  In order to be able ask question and answer the questions
  As an User
  I want be able to sign in with Twitter
} do

  context 'can sign in user with Twitter account' do
    background do
      visit new_user_session_path
      expect(page).to have_content("Sign in with Twitter")
      mock_twitter_auth_hash
      click_on "Sign in with Twitter"
    end

    scenario "sign in with temporary email" do
      expect(page).to have_content('temp_email_12345@twitter.com')
    end

    scenario 'confirm account by email' do
      clear_emails

      fill_in 'Email', with: 'test@example.com'
      click_on 'Continue'
      expect(page).to have_content('Please check your email')

      open_email('test@example.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  scenario "can handle authentication error" do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials

    visit new_user_session_path
    expect(page).to have_content("Sign in with Twitter")
    click_on "Sign in with Twitter"
    expect(page).to have_content('Could not authenticate')
  end
end
