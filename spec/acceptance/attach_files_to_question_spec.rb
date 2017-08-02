require_relative 'acceptance_helper'

feature 'Author can attach files to question', %q{
  In order to illustrate my question
  As an author of question
  I would like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Author can attach file when create question' do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'Author can attach multiple files whan create question', js: true do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    within all('.nested-fields').first do
      attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')
    end

    click_on 'add file'

    within all('.nested-fields').last do
      attach_file 'File', Rails.root.join('spec', 'rails_helper.rb')
    end

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
  end
end
