require 'rails_helper'

RSpec.describe "searches/edit", type: :view do
  before(:each) do
    @search = assign(:search, Search.create!(
      first_name: "MyString",
      last_name: "MyString",
      url: "MyString"
    ))
  end

  it "renders the edit search form" do
    render

    assert_select "form[action=?][method=?]", search_path(@search), "post" do

      assert_select "input[name=?]", "search[first_name]"

      assert_select "input[name=?]", "search[last_name]"

      assert_select "input[name=?]", "search[url]"
    end
  end
end
