require 'rails_helper'

feature 'Create answer the question', %q{
  In order to help other users
  As an authenticate user
  I want to be able to answer the question
  } do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario "Authenticate user can answer the question" do
    sign_in(user)

    visit question_path(question)
    fill_in 'Answer', with: 'Test Answer the question'
    click_on 'Create'
    expect(page).to have_content('Your answer succefully created.')
  end

  scenario "Non authenticate user cannot answer the question" do
    visit question_path(question)
    fill_in 'Answer', with: 'Test Answer the question'
    click_on 'Create'
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario "Create invalid answer" do
    sign_in(user)

    visit question_path(question)
    fill_in 'Answer', with: ''
    click_on 'Create'
    expect(page).to have_content('Errors:')
  end
end
