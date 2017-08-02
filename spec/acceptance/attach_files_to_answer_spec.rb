require_relative 'acceptance_helper'

feature 'Author can attach files to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I would like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'User can attach file when create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Answer', with: answer.body
    attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')
    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User can attach multiple files when create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Answer', with: question.body
    within all('.nested-fields').first do
      attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')
    end

    click_on 'add file'

    within all('.nested-fields').last do
      attach_file 'File', Rails.root.join('spec', 'rails_helper.rb')
    end
    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
