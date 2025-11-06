# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"
  step "Rubocop", "bin/rubocop -P"
  step "Tests: Rails", "bundle exec rspec --exclude-pattern 'system/*'"
  step "Tests: System", "bundle exec rspec spec/system"
end
