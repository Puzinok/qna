require 'rails_helper'

feature 'Create answer the question', %q{
  In order to help other users
  As an authenticate user
  I want to be able to answer the question
  } do

  scenario 'User can browse question page' do
    @question = create(:valid_question)

    visit question_path(@question)
    expect(page).to have_content("#{ @question.title }")
  end

  scenario "Authenticate user can answer the question" do
    User.create!(email: 'user@example.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    @question = create(:valid_question)

    visit question_path(@question)
    fill_in 'Answer', with: 'Test Answer the question'
    click_on 'Create'
    expect(page).to have_content('Your answer succefully created.')
  end

  scenario "Non authenticate user cannot answer the question" do
    @question = create(:valid_question)

    visit question_path(@question)
    fill_in 'Answer', with: 'Test Answer the question'
    click_on 'Create'
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
