# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"
  step "Rubocop", "bin/rubocop -P"
  step "Tests: Check file names", "bin/test-rspec-file-names"
  step "Tests: Rails", "bundle exec rspec --exclude-pattern 'system/*'"
  step "Tests: System", "bundle exec rspec spec/system"
  step "Coverage", "bin/test-coverage"
end
