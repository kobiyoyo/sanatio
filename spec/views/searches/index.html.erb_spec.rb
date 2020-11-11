require 'rails_helper'

RSpec.describe "searches/index", type: :view do
  before(:each) do
    assign(:searches, [
      Search.create!(
        first_name: "First Name",
        last_name: "Last Name",
        url: "Url"
      ),
      Search.create!(
        first_name: "First Name",
        last_name: "Last Name",
        url: "Url"
      )
    ])
  end

  it "renders a list of searches" do
    render
    assert_select "tr>td", text: "First Name".to_s, count: 2
    assert_select "tr>td", text: "Last Name".to_s, count: 2
    assert_select "tr>td", text: "Url".to_s, count: 2
  end
end
