unless ENV["NOCOVERAGE"]
  require "simplecov"
  SimpleCov.start
end

if ENV["CODECOV_TOKEN"]
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require "cucumber/rails"
require "agilibox/cucumber_config"
Agilibox::CucumberConfig.require_all_helpers!
Agilibox::CucumberConfig.require_cuprite!
Agilibox::CucumberConfig.require_common_steps!

Minifeed.config.entries_per_page = 10
