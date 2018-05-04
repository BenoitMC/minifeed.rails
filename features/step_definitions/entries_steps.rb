When("I go on the entries page") do
  visit main_app.entries_path
end

Given("an existing category named {string}") do |name|
  @category = create(:category, user: @user, name: name)
end

Given("an existing entry in this category") do
  @feed  = create(:feed, user: @user, category: @category)
  @entry = create(:entry, user: @user, feed: @feed)
end

Given("an existing entry in this category named {string}") do |name|
  step "an existing entry in this category"
  @entry.update!(name: name)
end

Given("an existing entry named {string}") do |name|
  @category = create(:category, user: @user)
  @feed     = create(:feed, user: @user, category: @category)
  @entry    = create(:entry, user: @user, feed: @feed, name: name)
end

Given("an existing starred entry named {string}") do |name|
  step %(an existing entry named "#{name}")
  @entry.update!(is_starred: true)
end
