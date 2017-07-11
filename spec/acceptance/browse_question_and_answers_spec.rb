require_relative 'acceptance_helper'

feature 'Show question and answers', %q{
  In order to get to solve my problem
  As an user
  I want to be browse question and answers to the question
} do

  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given(:user) { create(:user) }

  scenario 'Non Authenticated user browse question, answers' do
    visit question_path(question)
    expect(page).to have_content(question.body)
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end

  scenario 'Authenticated user browse question, answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content(question.body)
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end
