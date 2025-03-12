require "rails_helper"

describe "Keyboard Shortcuts", type: :system do
  before do
    @user = create(:user)
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    capybara_sign_in @user
  end

  it "shows keyboard shortcuts modal" do
    visit entries_path
    find("body").send_keys("h")
    expect(find("#modal")).to have_content("Keyboard shortcuts")
    find("body").send_keys("q")
    expect(page).to have_no_selector("#modal")
  end

  it "navigates with left/right arrows" do
    create(:entry, user: @user, feed: @feed, name: "i am the third entry")
    create(:entry, user: @user, feed: @feed, name: "i am the second entry")
    create(:entry, user: @user, feed: @feed, name: "i am the first entry")

    visit entries_path

    click_on "i am the first entry"
    expect(find("#modal")).to have_content("i am the first entry")

    find("body").send_keys(:right)
    expect(find("#modal")).to have_content("i am the second entry")

    find("body").send_keys(:right)
    expect(find("#modal")).to have_content("i am the third entry")

    find("body").send_keys(:right)
    expect(find("#modal")).to have_content("i am the third entry")

    find("body").send_keys(:left)
    expect(find("#modal")).to have_content("i am the second entry")

    find("body").send_keys(:left)
    expect(find("#modal")).to have_content("i am the first entry")

    find("body").send_keys(:left)
    expect(find("#modal")).to have_content("i am the first entry")
  end

  it "opens first entry with right arrow" do
    create(:entry, user: @user, feed: @feed, name: "i am the second entry")
    create(:entry, user: @user, feed: @feed, name: "i am the first entry")

    visit entries_path
    find("body").send_keys(:right)
    expect(find("#modal")).to have_content("i am the first entry")
  end

  it "opens last entry with left arrow" do
    create(:entry, user: @user, feed: @feed, name: "i am the second entry")
    create(:entry, user: @user, feed: @feed, name: "i am the first entry")

    visit entries_path
    find("body").send_keys(:left)
    expect(find("#modal")).to have_content("i am the second entry")
  end

  it "sets entry as read/unread" do
    create(:entry, user: @user, feed: @feed, name: "Example entry")
    visit entries_path
    click_on "Example entry"
    expect(page).to have_selector(".entry-is_read .fa-check-square")
    expect(page).to have_no_selector(".entry-is_read .fa-square")
    find("body").send_keys("r")
    expect(page).to have_selector(".entry-is_read .fa-square")
    expect(page).to have_no_selector(".entry-is_read .fa-check-square")
    find("body").send_keys("r")
    expect(page).to have_selector(".entry-is_read .fa-check-square")
    expect(page).to have_no_selector(".entry-is_read .fa-square")
  end

  it "sets entry as starred/unstarred" do
    create(:entry, user: @user, feed: @feed, name: "Example entry")

    visit entries_path
    click_on "Example entry"
    expect(page).to have_selector(".entry-is_starred .far.fa-star")
    expect(page).to have_no_selector(".entry-is_starred .fas.fa-star")
    find("body").send_keys("s")
    expect(page).to have_selector(".entry-is_starred .fas.fa-star")
    expect(page).to have_no_selector(".entry-is_starred .far.fa-star")
    find("body").send_keys("s")
    expect(page).to have_selector(".entry-is_starred .far.fa-star")
    expect(page).to have_no_selector(".entry-is_starred .fas.fa-star")
  end

  it "opens entry url in new tab" do
    create(:entry, user: @user, feed: @feed, name: "Example entry", url: "/tests.html")

    visit entries_path
    click_on "Example entry"
    find("body").send_keys("o")
  end

  it "opens entry url in modal" do
    create(:entry, user: @user, feed: @feed, name: "Example entry", url: "/tests.html")

    visit entries_path
    click_on "Example entry"
    find("body").send_keys("m")
    expect(page).to have_selector("iframe")
    expect(page).to have_selector("#modal")
  end

  it "opens reader mode in modal" do
    create(:entry, user: @user, feed: @feed, name: "Example entry", url: "/tests.html")

    visit entries_path
    click_on "Example entry"
    find("body").send_keys("p")
    expect(page).to have_selector("iframe")
    expect(page).to have_selector("#modal")
  end
end
