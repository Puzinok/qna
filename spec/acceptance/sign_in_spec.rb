require 'rails_helper'

feature 'Singin in', %q{
  In order to be able ask question and answer the questions
  As an User
  I want be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Existing User try to sign in' do
    sign_in(user)
    expect(page).to have_content('Signed in successfully.')
  end
end

