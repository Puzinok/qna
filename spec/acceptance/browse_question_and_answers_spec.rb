require 'rails_helper'

feature 'Show question and answers', %q{
  In order to get to solve my problem
  As an user
  I want to be browse question and answers to the question
} do

  given(:question) { create(:valid_question) }
  given!(:answers) { create_list(:valid_answer, 3, question: question) }
  given(:user) { create(:user) }

  scenario 'Non Authenticated user can browse question page' do
    visit question_path(question)
    expect(page).to have_content(question.body)
    expect(page).to have_content(answers.map(&:body).join)
  end

  scenario 'Authenticated user browse question, answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content(question.body)
    expect(page).to have_content(answers.map(&:body).join)
  end
end
