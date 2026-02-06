require "rails_helper"

describe "Entries", type: :system do
  before do
    @user = create(:user)
    capybara_sign_in @user
  end

  it "filters entries by category" do
    @category = create(:category, user: @user, name: "hello")
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "hello entry")

    @category = create(:category, user: @user, name: "world")
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "world entry")

    visit main_app.entries_path
    find("#nav_category_hello a").click
    expect(page).to have_content("hello entry")
    expect(page).to have_no_content("world entry")

    visit main_app.entries_path
    find("#nav_category_world a").click
    expect(page).to have_content("world entry")
    expect(page).to have_no_content("hello entry")
  end

  it "filters entries by starred" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "i am a starred entry")
    @entry.update!(is_starred: true)

    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "i am an other entry")

    visit main_app.entries_path
    find("#nav_starred a").click
    expect(page).to have_content("i am a starred entry")
    expect(page).to have_no_content("i am an other entry")
  end

  it "searches entries" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "ruby")

    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "rails")

    visit main_app.entries_path
    expect(page).to have_content("ruby")
    expect(page).to have_content("rails")
    fill_in :q, with: "ruby"
    find(".search-submit").click
    expect(page).to have_content("ruby")
    expect(page).to have_no_content("rails")
  end

  it "reads entry in modal" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "i am an entry")
    @entry.update!(body: "i am an entry body")

    visit main_app.entries_path
    click_on "i am an entry"
    expect(find(".modal")).to have_content("i am an entry")
    expect(find(".modal")).to have_content("i am an entry body")
  end

  it "opens entry url in new tab" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "Example entry")
    @entry.update!(url: "/tests.html")

    visit main_app.entries_path
    click_on "Example entry"
    find(".entry-external_link").click
    wait_for { windows.count }.to be > 1
    switch_to_window windows.last
    expect(page).to have_content("Hello World")
  end

  it "opens entry url in modal" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "Example entry")
    @entry.update!(url: "/tests.html")

    visit main_app.entries_path
    click_on "Example entry"
    find(".entry-internal_link").click
    expect(page).to have_selector("iframe")
    expect(page).to have_selector(".modal")
  end

  it "opens reader mode in modal" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "Example entry")
    @entry.update!(url: "/tests.html")

    visit main_app.entries_path
    click_on "Example entry"
    find(".entry-reader_link").click
    expect(page).to have_selector("iframe")
    expect(page).to have_selector(".modal")
  end

  it "opens entry body links in new page" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "Example entry")
    @entry.update!(body: "<a href='/tests.html'>entry body link</a>")

    visit main_app.entries_path
    click_on "Example entry"
    click_on "entry body link"
    wait_for { windows.count }.to be > 1
    switch_to_window windows.last
    expect(page).to have_content("Hello World")
  end

  it "sets entry as read/unread" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "Example entry")

    visit main_app.entries_path

    click_on "Example entry"
    expect(page).to have_selector(".entry-is_read .fa-check-square")
    expect(page).to have_no_selector(".entry-is_read .fa-square")

    find(".entry-is_read").click
    expect(page).to have_selector(".entry-is_read .fa-square")
    expect(page).to have_no_selector(".entry-is_read .fa-check-square")

    find(".entry-is_read").click
    expect(page).to have_selector(".entry-is_read .fa-check-square")
    expect(page).to have_no_selector(".entry-is_read .fa-square")
  end

  it "sets entry as starred/unstarred" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "Example entry")

    visit main_app.entries_path

    click_on "Example entry"
    expect(page).to have_selector(".entry-is_starred .far.fa-star")
    expect(page).to have_no_selector(".entry-is_starred .fas.fa-star")

    find(".entry-is_starred").click
    expect(page).to have_selector(".entry-is_starred .fas.fa-star")
    expect(page).to have_no_selector(".entry-is_starred .far.fa-star")

    find(".entry-is_starred").click
    expect(page).to have_selector(".entry-is_starred .far.fa-star")
    expect(page).to have_no_selector(".entry-is_starred .fas.fa-star")
  end

  it "refreshes read/unread on list" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    @entry.update!(name: "Example entry")

    visit main_app.entries_path
    expect(page).to have_no_selector(".entry.is_read")
    click_on "Example entry"
    find("body").send_keys("q")
    expect(page).to have_selector(".entry.is_read")
  end

  it "marks all as read globally" do
    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)

    visit main_app.entries_path
    expect(page).to have_selector(".entry")
    click_on "Mark all as read"
    expect(page).to have_no_selector(".entry")
  end

  it "marks all as read in category" do
    @category = create(:category, user: @user, name: "hello")
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)

    @category = create(:category, user: @user, name: "world")
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)

    visit main_app.entries_path

    find("#nav_category_hello a").click
    expect(page).to have_selector("#nav_category_hello.active")
    expect(page).to have_selector(".entry")

    click_on "Mark all as read"
    expect(page).to have_no_selector(".entry")

    find("#nav_category_world a").click
    expect(page).to have_selector("#nav_category_world.active")
    expect(page).to have_selector(".entry")
  end

  it "paginates entries" do
    expect(Minifeed.config).to receive(:entries_per_page).at_least(:once).and_return(10)

    @category = create(:category, user: @user)
    @feed = create(:feed, user: @user, category: @category)

    25.times do
      @entry = create(:entry, user: @user, feed: @feed)
    end

    visit main_app.entries_path
    expect(page).to have_selector(".entry", count: 10)

    click_on "Load more entries"
    expect(page).to have_selector(".entry", count: 20)

    click_on "Load more entries"
    expect(page).to have_selector(".entry", count: 25)

    expect(page).to have_no_content("Load more entries")
  end
end
