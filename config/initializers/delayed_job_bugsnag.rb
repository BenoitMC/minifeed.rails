module DelayedJobBugsnag
  def invoke_job(*)
    super
  rescue Exception => e
    Bugsnag.notify(e)
    raise e
  end
end

if defined? Delayed::Job
  Delayed::Job.send(:prepend, DelayedJobBugsnag)
end
