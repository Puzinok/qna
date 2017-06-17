require 'rails_helper'

feature 'Show question and answers', %q{
  In order to get to solve my problem
  As an user
  I want to be browse question and answers to the question
} do
  scenario 'User visit to question page' do
    @question = create(:valid_question)
    @answer1 = create(:valid_answer, question: @question)

    visit question_path(@question)
    expect(page).to have_content("#{ @answer1.body }")
  end
end
