require "agilibox/model_i18n"

Rails.application.config.after_initialize do
  I18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.yml").to_s]
  I18n.load_path = I18n.load_path.grep_v(/agilibox/)
  I18n.reload!
end

if Rails.env.test? || Rails.env.development?
  Rails.application.config.i18n.raise_on_missing_translations = true
  I18n.exception_handler = -> (exception, *) { raise exception }
  Agilibox::ModelI18n.raise_on_missing_translations = true
end

I18n.default_locale = :en
I18n.available_locales = [:en]
