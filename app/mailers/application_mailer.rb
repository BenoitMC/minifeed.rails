class ApplicationMailer < ActionMailer::Base
  DEFAULT_FROM = "minifeed@todo.example.org"

  default from: DEFAULT_FROM
  layout "mailer"
end
