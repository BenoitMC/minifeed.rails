source "https://rubygems.org"

gem "rails", "~> 5.0"

gem "carrierwave"
gem "devise"
gem "devise-i18n"
gem "devise-bootstrap-views", "0.0.9" # https://github.com/hisea/devise-bootstrap-views/issues/49
gem "uglifier"
gem "slim-rails"
gem "sass-rails"
gem "bootstrap-sass"
gem "simple_form"
gem "coffee-rails"
gem "jquery-rails"
gem "kaminari"
gem "turbolinks"
gem "bootstrap-kaminari-views"
gem "bh"
gem "rails-i18n"
gem "pundit"
gem "awesome_print"
gem "kaminari-i18n"
gem "bootstrap-datepicker-rails"
gem "execjs"
gem "therubyracer"
gem "autoprefixer-rails"
gem "font-awesome-sass"
gem "puma"
gem "bugsnag"
gem "nilify_blanks"

group :test do
  gem "minitest"
  gem "rspec-wait"
  gem "rails-controller-testing"
  gem "rspec-repeat"
  gem "shoulda-matchers", "2.5.0"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "poltergeist"
  gem "spring-commands-rspec"
  gem "spring-commands-cucumber"
  gem "guard"
  gem "guard-cucumber"
  gem "guard-rspec", "4.5.2" # https://github.com/guard/guard-rspec/issues/334
  gem "guard-rubocop"
  gem "timecop"
  gem "simplecov", require: false
  gem "pundit-matchers"
end

group :development do
  gem "desktop_delivery"
  gem "better_errors"
  gem "meta_request"

  # Please do not use this gem, it create Rails reloader problems
  # gem "binding_of_caller"
end

group :development, :test do
  gem "spring"
  gem "pry-rails"
  gem "launchy"
  gem "rails-erd"
  gem "thor"
  gem "faker"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "byebug"
  gem "rspec-rails" # must be in both environments for generators
end

group :production do
  gem "pg"
end
