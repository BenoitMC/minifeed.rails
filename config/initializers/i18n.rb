if Rails.env.test? || Rails.env.development?
  Rails.application.config.i18n.raise_on_missing_translations = true
  I18n.exception_handler = -> (exception, *) { raise exception }
end

I18n.default_locale = :en
I18n.available_locales = [:en]
