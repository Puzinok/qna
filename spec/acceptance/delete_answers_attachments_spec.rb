require_relative 'acceptance_helper'

feature 'Answers author can remove answer attachment', %q{
  In order to fix mistake
  As an author of answer
  I would like to be able to remove files
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: author)}
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Non author cannot see delete link', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link('delete file')
    end
  end

  scenario 'Author of answer can delete attachment', js: true do
    sign_in(author)
    visit question_path(question)

    within '.answers' do
      click_on('delete file')
      expect(page).to_not have_content(answer.attachments.first.file.identifier)
    end
  end
end
