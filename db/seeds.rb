if User.all.empty?
  user = User.create!(name: "Demo", email: "demo@example.org", password: "password", is_admin: true)

  category1 = Category.create!(user:, name: "Development")
  Feed.create!(user:, category: category1, name: "Ruby", url: "https://www.ruby-lang.org/en/feeds/news.rss")
  Feed.create!(user:, category: category1, name: "Ruby on Rails", url: "https://weblog.rubyonrails.org/feed/atom.xml")
  Feed.create!(user:, category: category1, name: "Crystal Lang", url: "https://crystal-lang.org/feed.xml")

  category2 = Category.create!(user:, name: "Comics")
  Feed.create!(user:, category: category2, name: "CommitStrip", url: "https://www.commitstrip.com/en/feed/")
  Feed.create!(user:, category: category2, name: "MonkeyUser", url: "https://www.monkeyuser.com/index.xml")
end
