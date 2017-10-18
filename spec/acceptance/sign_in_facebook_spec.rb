require_relative 'acceptance_helper'

feature 'Singin in', %q{
  In order to be able ask question and answer the questions
  As an User
  I want be able to sign in with Facebook
} do

  scenario "can sign in user with Facebook account" do
    visit new_user_session_path
    expect(page).to have_content("Sign in with Facebook")
    mock_auth_hash
    click_on "Sign in with Facebook"
    expect(page).to have_content('mock@email.com')
  end

  scenario "can handle authentication error" do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials

    visit new_user_session_path
    expect(page).to have_content("Sign in with Facebook")
    click_on "Sign in with Facebook"
    expect(page).to have_content('Could not authenticate')
  end
end
