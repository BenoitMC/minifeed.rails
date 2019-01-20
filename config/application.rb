require_relative 'boot'

require 'rails/all'

require_relative "../lib/ext/rails"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Minifeed
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = ENV["TZ"].presence || "UTC"

    config.action_mailer.delivery_method = :sendmail

    config.active_record.primary_key = :uuid
    config.active_record.belongs_to_required_by_default = false

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.action_view.form_with_generates_remote_forms = false
  end

  class Config
    attr_accessor(
      :autoimport_enabled,
      :autoimport_interval,
      :entries_per_page,
    )
  end

  cattr_accessor :config

  self.config = Config.new
end
