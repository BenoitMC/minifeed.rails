source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(File.join(__dir__, ".ruby-version"))

gem "dotenv", require: "dotenv/load" # Keep it first

gem "rails", "~> 7.1.0"
gem "agilidee-devise", ">= 1.1.2"

gem "bootsnap", require: false
gem "rufus-scheduler"
gem "feedjira"
gem "feedjira-youtube"
gem "feedbag"
gem "metainspector"
gem "sprockets-rails"
gem "cssbundling-rails"
gem "terser"
gem "turbo-rails"
gem "slim-rails"
gem "simple_form"
gem "kaminari"
gem "pundit"
gem "autoprefixer-rails"
gem "puma"
gem "bugsnag"
gem "pg"
gem "loofah"
gem "http"
gem "attr_extras", require: "attr_extras/explicit"
gem "goldiloader"
gem "nilify_blanks"
gem "rails-i18n"
gem "awesome_print"
gem "pry-rails"

group :test do
  gem "minitest"
  gem "rspec-wait"
  gem "rails-controller-testing"
  gem "shoulda-matchers"
  gem "temping"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "cuprite"
  gem "simplecov", require: false
  gem "zonebie"
end

group :development do
  gem "desktop_delivery"
  gem "better_errors"
end

group :development, :test do
  gem "listen"
  gem "launchy"
  gem "thor"
  gem "faker"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "byebug"
  gem "rspec-rails" # must be in both environments for generators
  gem "rubocop", "1.60.2", require: false
  gem "rubocop-performance", "1.20.2", require: false
  gem "rubocop-rails", "2.23.1", require: false
end
