class ApplicationMailer < ActionMailer::Base
  DEFAULT_FROM = "mom@example.org"

  default from: DEFAULT_FROM
end
