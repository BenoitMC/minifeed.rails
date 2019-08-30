class ThreadPool
  WAIT_INTERVAL = 0.1

  def initialize(size)
    @pool = Concurrent::FixedThreadPool.new(size)
  end

  def post
    # It is important that a job never crashes to compare completed vs scheduled
    wrapped_job = -> do
      begin
        yield
      rescue Exception # rubocop:disable Lint/RescueException
        nil
      end
    end

    @pool.post(&wrapped_job)
  end

  def empty?
    @pool.completed_task_count == @pool.scheduled_task_count
  end

  def any?
    !empty?
  end

  def wait
    loop do
      break if empty?
      sleep WAIT_INTERVAL
    end
  end
end
