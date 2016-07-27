if %w(production staging).include?(Rails.env)
  Rails.application.config.middleware.use(ExceptionNotification::Rack,
    :email => {
      :email_prefix         => "[#{Rails.application.class.parent_name} #{Rails.env}] ",
      :sender_address       => %{"#{Rails.application.class.parent_name} Notifier" <#{ApplicationMailer::DEFAULT_FROM}>},
      :exception_recipients => %w{support@agilidee.com},
    }
  )
end

module DelayedJobExceptionNotification
  def invoke_job(*)
    super
  rescue Exception => e
    if self.attempts == 0
      ExceptionNotifier.notify_exception(e)
    end

    raise e
  end
end

if defined? Delayed::Job
  Delayed::Job.send(:prepend, DelayedJobExceptionNotification)
end
