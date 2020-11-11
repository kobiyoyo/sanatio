require 'rails_helper'

RSpec.describe "searches/new", type: :view do
  before(:each) do
    assign(:search, Search.new(
      first_name: "MyString",
      last_name: "MyString",
      url: "MyString"
    ))
  end

  it "renders new search form" do
    render

    assert_select "form[action=?][method=?]", searches_path, "post" do

      assert_select "input[name=?]", "search[first_name]"

      assert_select "input[name=?]", "search[last_name]"

      assert_select "input[name=?]", "search[url]"
    end
  end
end
