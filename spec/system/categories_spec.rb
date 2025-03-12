require "rails_helper"

describe "Categories", type: :system do
  before do
    @user = create(:user)
    capybara_sign_in @user
  end

  it "reorders categories" do
    create(:category, user: @user, name: "hello")
    create(:category, user: @user, name: "world")
    visit settings_categories_path
    expect(source.index("hello") < source.index("world")).to be true
    click_on "Reorder"
    expect(page).to have_selector ".handle"
    # TODO : use real drag and drop
    execute_script %(
      let el = find("tbody tr:last-child")
      el.parentNode.insertBefore(el, find("tbody tr:first-child"))
      find(".sortable").triggerEvent("sortupdate")
    )
    click_on "Save"
    expect(page).to have_content "Categories successfully reordered"
    expect(source.index("world") < source.index("hello")).to be true
  end
end
