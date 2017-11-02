require_relative '../acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistakes in question
  As an author of question
  I want to be able edit my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link('Edit')
  end

  context 'Author' do
    given!(:author_question) { create(:question, user: user) }

    before do
      sign_in(user)
      visit question_path(author_question)
    end

    scenario 'can see edit link for question' do
      within '#question' do
        expect(page).to have_link('Edit')
      end
    end

    scenario 'try to edit his question', js: true do
      within '#question' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content(author_question.body)
        expect(page).to have_content('edited title')
        expect(page).to have_content('edited body')
        expect(page).to_not have_selector('textarea')
      end
    end

    scenario 'try to save invalid question', js: true do
      within '#question' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content("Title can't be blank")
        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  scenario "Non author try edit question" do
    sign_in(another_user)
    visit question_path(question)

    within '#question' do
      expect(page).to_not have_link('Edit')
    end
  end
end
