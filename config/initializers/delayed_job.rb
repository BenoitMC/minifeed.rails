if defined? Delayed::Job
  if Rails.env.test? || Rails.env.development?
    Delayed::Worker.delay_jobs = false
  else
    Delayed::Worker.delay_jobs = true
  end
end
