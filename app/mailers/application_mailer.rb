class ApplicationMailer < ActionMailer::Base
  DEFAULT_FROM = Rails.configuration.x.mailer_default_from

  default from: DEFAULT_FROM

  layout "mailer"
end
