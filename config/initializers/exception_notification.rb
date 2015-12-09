if %w(production staging).include?(Rails.env)
  Rails.application.config.middleware.use(ExceptionNotification::Rack,
    :email => {
      :email_prefix         => "[Mom #{Rails.env}] ",
      :sender_address       => %{"BuyCo Notifier" <mom@example.org>},
      :exception_recipients => %w{support@agilidee.com},
    }
  )
end
