unless ENV["NOCOVERAGE"]
  require "simplecov"
  # SimpleCov.start
end

if ENV["CODECOV_TOKEN"]
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require "cucumber/rails"

Minifeed.config.entries_per_page = 10
