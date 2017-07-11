require_relative 'acceptance_helper'

feature 'Browse all questions', %q{
  In order to find question or answer
  As an user
  I want to be able browse all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'User can browse all questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end

  scenario 'Authenticated user browse all questions' do
    sign_in(user)
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end
end
