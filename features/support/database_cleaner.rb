require "database_cleaner"

Cucumber::Rails::Database.autorun_database_cleaner = false
Cucumber::Rails::Database.javascript_strategy      = :truncation

After do |_scenario, _block|
  tables = %w(
    ar_internal_metadata
    schema_migrations
    spatial_ref_sys
  )

  DatabaseCleaner.clean_with(:truncation, except: tables)
end
