require_relative 'acceptance_helper'

feature 'Used can search', %q{
  In order to find solution
  An as user or guest
  I want to be able search
} do

  given!(:question) { create(:question) } 

  context 'User can search' do
    background do
      index
      visit search_path
    end

    scenario 'see search form' do
      expect(page).to have_css('#search')
    end
    
    scenario 'Show results if found', js: true do
      fill_in 'search', with: question.body
      click_button 'Search'

      expect(page).to have_content(question.body)
    end

    scenario 'Show message if not found', skip: true do
      fill_in 'search', with: "Another query"
      click_button 'Search'

      expect(page).to have_content("Nothing found!")
    end
  end
end
