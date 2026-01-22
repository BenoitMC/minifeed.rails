source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

gem "dotenv", require: "dotenv/load" # Keep it first

gem "rails", "~> 8.1.0"

gem "bootsnap", require: false
gem "solid_queue"
gem "feedjira"
gem "feedjira-youtube"
gem "feedbag"
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
gem "openssl" # Fix https://github.com/ruby/openssl/issues/949

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
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
end
