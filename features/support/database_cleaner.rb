DatabaseCleaner.strategy                      = :transaction
Cucumber::Rails::Database.javascript_strategy = :transaction

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end
