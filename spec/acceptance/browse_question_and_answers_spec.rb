require 'rails_helper'

feature 'Show question and answers', %q{
  In order to get to solve my problem
  As an user
  I want to be browse question and answers to the question
} do
  scenario 'User visit to question page' do
    @question = create(:valid_question)
    @answers = create_list(:valid_answer, 3, question: @question)

    visit question_path(@question)
    expect(page).to have_css('.answer_body', count: 3)
  end
end
