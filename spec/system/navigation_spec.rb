require "rails_helper"

describe "Navigation", type: :system do
  before do
    @user = create(:user)
    capybara_sign_in @user
  end

  it "activates navigation category" do
    @category = create(:category, user: @user, name: "hello")
    @category = create(:category, user: @user, name: "world")
    visit entries_path
    ids = ["all_entries"]
    ids.each do |id|
      expect(page).to have_selector("#nav_#{id}.active")
    end
    expect(page).to have_selector("#nav .active", count: ids.length)
    find("#nav_starred a").click
    ids = ["starred"]
    ids.each do |id|
      expect(page).to have_selector("#nav_#{id}.active")
    end
    expect(page).to have_selector("#nav .active", count: ids.length)
    find("#nav_category_hello a").click
    ids = ["category_hello"]
    ids.each do |id|
      expect(page).to have_selector("#nav_#{id}.active")
    end
    expect(page).to have_selector("#nav .active", count: ids.length)
    find("#nav_category_world a").click
    ids = ["category_world"]
    ids.each do |id|
      expect(page).to have_selector("#nav_#{id}.active")
    end
    expect(page).to have_selector("#nav .active", count: ids.length)
  end

  it "activates navigation feed" do
    @category = create(:category, user: @user, name: "hello")
    @feed = create(:feed, user: @user, category: @category, name: "world")
    visit entries_path
    expect(page).to have_no_content("world")
    find("#nav_category_hello .subnav-toggle").click
    expect(page).to have_content("world")
    click_on "world"
    ids = %w[category_hello feed_world]
    ids.each do |id|
      expect(page).to have_selector("#nav_#{id}.active")
    end
    expect(page).to have_selector("#nav .active", count: ids.length)
  end

  it "remembers active navigation type" do
    @category = create(:category, user: @user, name: "ruby")
    @category = create(:category, user: @user, name: "rails")
    visit entries_path
    find("#nav_category_ruby a").click
    ids = ["category_ruby"]
    ids.each do |id|
      expect(page).to have_selector("#nav_#{id}.active")
    end
    expect(page).to have_selector("#nav .active", count: ids.length)
    find(".filter.starred").click
    expect(page).to have_selector(".filter.starred.active")
    find("#nav_category_rails a").click
    ids = ["category_rails"]
    ids.each do |id|
      expect(page).to have_selector("#nav_#{id}.active")
    end
    expect(page).to have_selector("#nav .active", count: ids.length)
    expect(page).to have_selector(".filter.starred.active")
  end

  it "hides navigation badges if 0" do
    @category = create(:category, user: @user, name: "hello")
    @category = create(:category, user: @user, name: "world")
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed)
    visit entries_path
    expect(page).to have_no_selector("#nav_category_hello .badge")
    expect(page).to have_selector("#nav_category_world .badge")
  end

  it "live reloads navigation" do
    @category = create(:category, user: @user, name: "hello")
    @feed = create(:feed, user: @user, category: @category)
    @entry = create(:entry, user: @user, feed: @feed, name: "Example entry")
    @category = create(:category, user: @user)
    visit entries_path
    expect(page).to have_selector("#nav_all_entries .badge")
    expect(page).to have_selector("#nav_category_hello .badge")
    expect(page).to have_no_selector("#nav_starred .badge")
    click_on "Example entry"
    expect(page).to have_no_selector("#nav_all_entries .badge")
    expect(page).to have_no_selector("#nav_category_hello .badge")
    expect(page).to have_no_selector("#nav_starred .badge")
    find(".entry-is_starred").click
    expect(page).to have_no_selector("#nav_all_entries .badge")
    expect(page).to have_no_selector("#nav_category_hello .badge")
    expect(page).to have_selector("#nav_starred .badge")
    find(".entry-is_read").click
    expect(page).to have_selector("#nav_all_entries .badge")
    expect(page).to have_selector("#nav_category_hello .badge")
    expect(page).to have_selector("#nav_starred .badge")
  end
end
