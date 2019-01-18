if User.all.empty?
  user = User.create!(email: "demo@example.org", password: "password")

  category1 = Category.create!(user: user, name: "Development")
  Feed.create!(user: user, category: category1, name: "Ruby", url: "https://www.ruby-lang.org/fr/feeds/news.rss")
  Feed.create!(user: user, category: category1, name: "Ruby on Rails", url: "https://weblog.rubyonrails.org/feed/atom.xml")
  Feed.create!(user: user, category: category1, name: "Crystal Lang", url: "https://crystal-lang.org/feed.xml")

  category2 = Category.create!(user: user, name: "Comics")
  Feed.create!(user: user, category: category2, name: "CommitStrip", url: "https://www.commitstrip.com/en/feed/")
  Feed.create!(user: user, category: category2, name: "MonkeyUser", url: "https://www.monkeyuser.com/feed.xml")
end
