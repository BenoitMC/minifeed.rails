if defined? Delayed::Job
  Rails.application.config.active_job.queue_adapter = :delayed_job

  if Rails.env.test? || Rails.env.development?
    Delayed::Worker.delay_jobs = false
  else
    Delayed::Worker.delay_jobs = true
  end
end
