require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an User
  I want to be able create a question
} do

  scenario 'User create the question' do
    visit new_question_path
    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test Question'
    click_on 'Create'

    expect(page).to have_content 'Your question succefully created.'
  end
end
