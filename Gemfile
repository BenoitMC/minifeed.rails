source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(File.join(__dir__, ".ruby-version"))

gem "dotenv-rails", require: "dotenv/rails-now" # Keep it first

gem "rails", "~> 5.2.2"
gem "agilidee-devise", ">= 1.1.2"
gem "agilibox", "1.5.4"

gem "bootsnap"
gem "rufus-scheduler"
gem "feedjira"
gem "feedbag"
gem "uglifier"
gem "slim-rails"
gem "sassc-rails"
gem "bootstrap"
gem "simple_form"
gem "coffee-rails"
gem "jquery-rails"
gem "kaminari"
gem "turbolinks"
gem "bootstrap-kaminari-views"
gem "rails-i18n"
gem "pundit"
gem "awesome_print"
gem "pry-rails"
gem "kaminari-i18n"
gem "bootstrap-datepicker-rails"
gem "execjs"
gem "mini_racer"
gem "autoprefixer-rails"
gem "font-awesome-sass"
gem "puma"
gem "bugsnag"
gem "nilify_blanks"
gem "pg"
gem "loofah"

group :test do
  gem "minitest"
  gem "rspec-wait"
  gem "rails-controller-testing"
  gem "rspec-repeat"
  gem "shoulda-matchers", ">=4.0.0.rc1"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "selenium-webdriver"
  gem "chromedriver-helper"
  gem "spring-commands-rspec"
  gem "spring-commands-cucumber"
  gem "timecop"
  gem "simplecov", require: false
  gem "pundit-matchers"
  gem "zonebie"
  gem "codecov", require: false
end

group :development do
  gem "desktop_delivery"
  gem "better_errors"
  gem "meta_request"
end

group :development, :test do
  gem "spring"
  gem "listen"
  gem "launchy"
  gem "rails-erd"
  gem "thor"
  gem "faker"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "byebug"
  gem "rspec-rails" # must be in both environments for generators
  gem "rubocop", "0.62.0", require: false
end
