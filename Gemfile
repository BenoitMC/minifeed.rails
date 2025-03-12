source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(File.join(__dir__, ".ruby-version"))

gem "dotenv", require: "dotenv/load" # Keep it first

gem "rails", "~> 8.0.0"

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
gem "ostruct"
gem "bcrypt"

group :test do
  gem "rspec-wait"
  gem "rails-controller-testing"
  gem "shoulda-matchers"
  gem "temping"
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
  gem "faker"
  gem "factory_bot_rails"
  gem "rspec-rails" # must be in both environments for generators
  gem "rubocop", "1.72.2", require: false
  gem "rubocop-performance", "1.24.0", require: false
  gem "rubocop-rails", "2.30.1", require: false
end
