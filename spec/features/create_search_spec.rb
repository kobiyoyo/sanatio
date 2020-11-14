require 'rails_helper'

feature 'create search' do

  let(:no_record){'No Record found'}
  let(:record_found){'Search was successfully found.'}

  scenario 'successfully check when not in database' do
    visit(searches_path)
    fill_in 'First name', with: 'Ben'
    fill_in 'Last name', with: 'Pratt'
    fill_in 'Url', with: '8returns.com'
    click_on('Search Name')
    expect(page).to have_content(record_found)
  end

  scenario 'unsuccessfully check when not in database' do
    visit(searches_path)
    fill_in 'First name', with: 'Chubi'
    fill_in 'Last name', with: 'Adama'
    fill_in 'Url', with: '8returns.com'
    click_on('Search Name')
    page.body.should match(%r{#{no_record}}i)
  end
  scenario 'successfully check when in database' do
    visit(searches_path)
    Search.create(email:"ben@8returns.com",first_name:"Ben",last_name:"Pratt",url:"8returns.com",status: "approved")
    fill_in 'First name', with: 'Ben'
    fill_in 'Last name', with: 'Pratt'
    fill_in 'Url', with: '8returns.com'
    click_on('Search Name')
    expect(page).to have_content(record_found)
  end

  scenario 'unsuccessfully check when in database' do
    Search.create(email:"adama@8returns.com",first_name:"Chubi",last_name:"Adama",url:"8returns.com",status: "unapproved")
    visit(searches_path)
    fill_in 'First name', with: 'Chubi'
    fill_in 'Last name', with: 'Adama'
    fill_in 'Url', with: '8returns.com'
    click_on('Search Name')
    page.body.should match(%r{#{no_record}}i)
  end
end
