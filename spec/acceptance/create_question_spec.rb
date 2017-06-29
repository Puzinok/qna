require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an Authenticated User
  I want to be able create a question
} do

  context 'Authenticated User' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    background { sign_in(user) }

    scenario 'can create the question' do
      visit new_question_path
      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
      click_on 'Create'

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end

    scenario 'cannot create invalid question' do
      visit new_question_path
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Create'
      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content("Body can't be blank")
    end
  end

  scenario "Non Authenticated User can't create question" do
    visit new_question_path
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
