require_relative 'acceptance_helper'

feature 'Singin in', %q{
  In order to be able ask question and answer the questions
  As an User
  I want be able to sign in
} do

  given(:user) { create(:user) }
  given(:unregistered_user) { User.new(email: 'user@test.com', password: '12345678') }

  scenario 'Existing User try to sign in' do
    sign_in(user)
    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'Non register user try to sign in' do
    sign_in(unregistered_user)
    expect(page).to have_content('Invalid Email or password.')
  end
end
