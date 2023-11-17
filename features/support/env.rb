unless ENV["NOCOVERAGE"]
  require "simplecov"
  # SimpleCov.start
end

require "cucumber/rails"

Minifeed.config.entries_per_page = 10
