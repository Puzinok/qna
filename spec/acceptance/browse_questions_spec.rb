require 'rails_helper'

feature 'Browse all questions', %q{
  In order to find question or answer
  As an user
  I want to be able browse all questions
} do

  scenario 'User can browse all questions' do
    @questions = create_list(:valid_question, 3)
    visit '/questions'
    expect(page).to have_css('.question_title', count: 3)
  end
end
