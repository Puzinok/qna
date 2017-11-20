require_relative 'acceptance_helper'

feature 'Used can search', %q{
  In order to find solution
  An as user or guest
  I want to be able search
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer) }
  given!(:user) { create(:user) }

  context 'User can search' do
    background do
      index
      visit search_path
    end

    %w(question answer comment).each do |resource|
      scenario "search in #{resource}", js: true do
        fill_in 'search', with: eval(resource.to_s).send(:body)
        select(resource.to_s, from: 'resource')
        click_button 'Search'

        expect(page).to have_content(eval(resource.to_s).send(:body))
      end
    end

    scenario "search in user", js: true do
      fill_in 'search', with: user.email
      select("user", from: 'resource')
      click_button 'Search'

      expect(page).to have_content(user.email)
    end
  end

  describe 'search in all' do
    background do
      index
      visit search_path
    end

    given!(:question) { create(:question, body: 'search_query', title: 'search_query') }
    given!(:answer) { create(:answer, body: 'search_query') }
    given!(:comment) { create(:comment, commentable: answer, body: 'search_query') }
    given!(:user) { create(:user, email: 'search_query@example.com') }

    scenario 'search in all resources', js: true do
      fill_in 'search', with: 'search_query'
      select('all', from: 'resource')
      click_button 'Search'

      expect(page).to have_link 'search_query', href: question_path(question)
      expect(page).to have_link 'search_query', href: answer_path(answer)
      expect(page).to have_link 'search_query', href: comment_path(comment)
      expect(page).to have_content 'search_query@example.com'
    end
  end
end
