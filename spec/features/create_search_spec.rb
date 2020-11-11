require 'rails_helper'

feature 'create search' do
  scenario 'successfully' do
    visit(searches_path)
    fill_in 'First name', with: 'Ben'
    fill_in 'Last name', with: 'Pratt'
    fill_in 'Url', with: '8returns.com'
    click_on('Search')
    expect(page).to have_content('Search was successfully created.')
  end

  scenario 'unsuccessfully' do
    visit(searches_path)
    fill_in 'First name', with: 'Hello'
    fill_in 'Last name', with: 'Pratt'
    fill_in 'Url', with: '8returns.com'
    click_on('Search')
    expect(page).to have_content("No Record found")
  end
end