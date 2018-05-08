When("I go on the entries page") do
  visit main_app.entries_path
end

Given("an existing category named {string}") do |name|
  @category = create(:category, user: @user, name: name)
end

Given("an existing feed named {string}") do |name|
  @feed = create(:feed, user: @user, category: @category, name: name)
end

Given("an existing entry") do
  @category ||= create(:category, user: @user)

  @feed  = create(:feed, user: @user, category: @category)
  @entry = create(:entry, user: @user, feed: @feed)
end

Given("this existing entry {string} is {string}") do |k, v|
  @entry.update!(k => v)
end

Given("this existing entry is starred") do
  @entry.update!(is_starred: true)
end

Given("{int} existing entries") do |n|
  @category = create(:category, user: @user)
  @feed     = create(:feed, user: @user, category: @category)

  n.times do
    @entry = create(:entry, user: @user, feed: @feed)
  end
end
