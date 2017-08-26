require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistakes in answer
  As an author of answer
  I want to be able edit my answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link('Edit')
  end

  context 'Author' do
    given!(:author_answer) { create(:answer, question: question, user: user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can see edit link for answer' do
      within '.answers' do
        expect(page).to have_link('Edit')
      end
    end

    scenario 'try to edit his answer', js: true do
      within '.answers' do
        click_on 'Edit'
        within '.edit_answer' do
          fill_in 'Answer', with: 'edited body'
          click_on 'Save'
        end

        expect(page).to_not have_content(author_answer.body)
        expect(page).to have_content('edited body')
        expect(page).to_not have_selector('.edit_answer')
      end
    end

    scenario 'try to save invalid answer', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Answer', with: ''
        click_on 'Save'

        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  scenario "Non author try edit answer" do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link('Edit')
    end
  end
end
