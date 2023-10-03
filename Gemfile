source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(File.join(__dir__, ".ruby-version"))

gem "dotenv-rails", require: "dotenv/rails-now" # Keep it first

gem "rails", "~> 7.0.0"
gem "agilidee-devise", ">= 1.1.2"
gem "bmc"

gem "bootsnap", require: false
gem "rufus-scheduler"
gem "feedjira"
gem "feedjira-youtube"
gem "feedbag"
gem "terser"
gem "slim-rails"
gem "sassc-rails"
gem "bootstrap", "~> 5.0"
gem "simple_form"
gem "kaminari"
gem "turbo-rails"
gem "pundit"
gem "execjs"
gem "autoprefixer-rails"
gem "font-awesome-sass"
gem "puma", "~> 5.0"
gem "bugsnag"
gem "pg"
gem "loofah"
gem "http"
gem "sprockets"
gem "attr_extras", require: "attr_extras/explicit"
gem "goldiloader"
gem "rails-i18n"

group :test do
  gem "minitest"
  gem "rspec-wait"
  gem "rails-controller-testing"
  gem "shoulda-matchers"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "cuprite"
  gem "simplecov", require: false
  gem "zonebie"
  gem "codecov", require: false
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
  gem "rubocop", "1.54.1", require: false
  gem "rubocop-performance", "1.18.0", require: false
  gem "rubocop-rails", "2.20.2", require: false
end
