require "capybara/cuprite"

Capybara.register_driver :minifeed_cuprite do |app|
  Capybara::Cuprite::Driver.new(app,
    :browser_options => {
      :"disable-gpu" => true,
      :"no-sandbox" => nil,
    },
    :headless => (ENV["CHROME_HEADLESS"].to_s != "false"),
    :inspector => true,
    :js_errors => true,
    :process_timeout => 30,
    :timeout => 30,
    :window_size => [1680, 1050],
  )
end

Capybara.default_driver    = :minifeed_cuprite
Capybara.current_driver    = :minifeed_cuprite
Capybara.javascript_driver = :minifeed_cuprite
