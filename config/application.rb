require_relative "boot"

require "rails/all"

require_relative "../lib/ext/rails"
require_relative "../lib/minifeed/config.rb"
require_relative "minifeed.rb"

Bundler.require(*Rails.groups)

module Minifeed
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets ext tasks])

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
