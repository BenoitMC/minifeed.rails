require "capybara/cuprite"

Capybara.register_driver :custom_cuprite do |app|
  Capybara::Cuprite::Driver.new(app,
    browser_options: {
      "disable-gpu": true,
      "no-sandbox": nil,
    },
    headless: (ENV["CHROME_HEADLESS"].to_s != "false"),
    inspector: true,
    js_errors: true,
    process_timeout: 15,
    timeout: 15,
    window_size: [1680, 1050],
  )
end

Capybara.default_max_wait_time = 3

RSpec.configure do |config|
  config.before(type: :system) do
    driven_by :custom_cuprite
  end
end
