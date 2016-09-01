require 'database_cleaner'

Cucumber::Rails::Database.autorun_database_cleaner = false
Cucumber::Rails::Database.javascript_strategy      = :truncation

After do |scenario, block|
  DatabaseCleaner.clean_with(:truncation, {except: %w(
    ar_internal_metadata
    schema_migrations
    spatial_ref_sys
  )})
end
