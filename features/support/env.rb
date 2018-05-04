require "cucumber/rails"
require "agilibox/cucumber_config"
Agilibox::CucumberConfig.require_all_helpers!

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    :chromeOptions => {args: %w(headless disable-gpu window-size=1680,1050)},
  )

  Capybara::Selenium::Driver.new(app,
    :browser              => :chrome,
    :desired_capabilities => capabilities,
  )
end

Capybara.default_driver    = :headless_chrome
Capybara.current_driver    = :headless_chrome
Capybara.javascript_driver = :headless_chrome
