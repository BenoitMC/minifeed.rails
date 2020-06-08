require_relative 'boot'

require 'rails/all'

require_relative "../lib/ext/rails"
require_relative "../lib/minifeed/config.rb"
require_relative "minifeed.rb"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Minifeed
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.autoloader = :classic

    config.time_zone = ENV["TZ"].presence || "UTC"

    config.x.hostname = ENV["RAILS_HOSTNAME"].presence || "localhost"

    config.x.mailer_default_from = ENV["RAILS_MAILER_DEFAULT_FROM"].presence || "noreply@#{config.x.hostname}"

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = {host: config.x.hostname}
    config.action_mailer.delivery_method = :sendmail

    config.active_record.primary_key = :uuid
    config.active_record.belongs_to_required_by_default = false

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.action_view.form_with_generates_remote_forms = false
  end
end
