require 'rails_helper'

feature 'Create answer the question', %q{
  In order to help other users
  As an user
  I want to be able to answer the question
  } do

  scenario 'User try to browse question page' do
    @question = create(:valid_question)

    visit question_path(@question)
    expect(page).to have_content("#{ @question.title }")
  end

  scenario 'User try to create answer the question' do
    @question = create(:valid_question)

    visit question_path(@question)
    fill_in 'Answer', with: 'Test Answer the question'
    click_on 'Create'
  end
end
