require_relative "production.rb"

Rails.application.configure do
  config.action_mailer.default_url_options = {host: "staging.mom.example.org"}
end
