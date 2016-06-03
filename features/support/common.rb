require "capybara/poltergeist"

ActionController::Base.allow_rescue = false

phantomjs_version = "2.1.1"
phantomjs_binary = `which phantomjs-#{phantomjs_version} phantomjs`.split("\n").first
raise "invalid phantomjs version" unless `#{phantomjs_binary} -v`.strip == phantomjs_version
# You can download phantomjs here : https://bitbucket.org/ariya/phantomjs/downloads/
# Semaphore setup commmand : change-phantomjs-version 2.1.1

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    :debug       => false,
    :window_size => [1680, 1050],
    :timeout     => 60,
    :phantomjs   => phantomjs_binary,
  )
end

Capybara.default_driver        = :poltergeist
Capybara.javascript_driver     = :poltergeist
Capybara.current_driver        = :poltergeist
Capybara.default_max_wait_time = 3

DatabaseCleaner.strategy                      = :transaction
Cucumber::Rails::Database.javascript_strategy = :transaction

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

module CucumberAuthentication
  include Warden::Test::Helpers

  def sign_out
    logout
  end

  def sign_in(user)
    sign_out
    visit(new_user_session_path)
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find("[type=submit]").click
  end
end

World(CucumberAuthentication)
World(FactoryGirl::Syntax::Methods)
