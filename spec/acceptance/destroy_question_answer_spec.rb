require 'rails_helper'

feature 'User delete own question or answer', %q{
  In order to delete wrong question or answer
  As an authenticate user
  I want to be able to delete own question or answer
} do
  given(:user) { create(:user) }

  scenario 'User can delete own question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    @question = Question.create!(title: 'Test title', body: 'Question body', user: :current_user)
    visit question_path(@question)
    click_on 'Delete'

    expect(page).to have_content('Your question succefully deleted!')
  end

  scenario 'User cannot delete not owned him question'
end
