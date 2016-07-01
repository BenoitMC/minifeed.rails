if %w(production staging).include?(Rails.env)
  Rails.application.config.middleware.use(ExceptionNotification::Rack,
    :email => {
      :email_prefix         => "[#{Rails.application.class.parent_name} #{Rails.env}] ",
      :sender_address       => %{"#{Rails.application.class.parent_name} Notifier" <#{ApplicationMailer::DEFAULT_FROM}>},
      :exception_recipients => %w{support@agilidee.com},
    }
  )
end
