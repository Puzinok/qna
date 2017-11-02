require_relative '../acceptance_helper'

feature 'Author can remove questions attachment', %q{
  In order to fix mistake
  As an author of question
  I would like to be able to remove files
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Non author cannot see delete link', js: true do
    sign_in(user)
    visit question_path(question)

    within '#attachments' do
      expect(page).to_not have_link('delete file')
    end
  end

  scenario 'Author of question can delete attachment', js: true do
    sign_in(author)
    visit question_path(question)

    within '#attachments' do
      click_on('delete file')
      expect(page).to_not have_content(question.attachments.first.file.identifier)
    end
  end
end
