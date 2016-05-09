require "capybara/poltergeist"

ActionController::Base.allow_rescue = false

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    :debug       => false,
    :window_size => [1680, 1050],
    :timeout     => 60,
  )
end

Capybara.current_driver    = :poltergeist
Capybara.javascript_driver = :poltergeist

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
