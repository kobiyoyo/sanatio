require 'rails_helper'

RSpec.describe "searches/show", type: :view do
  before(:each) do
    @search = assign(:search, Search.create!(
      first_name: "First Name",
      last_name: "Last Name",
      url: "Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Url/)
  end
end
