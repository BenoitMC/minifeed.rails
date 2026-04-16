class ApplicationJob < ActiveJob::Base
  discard_on ActiveJob::DeserializationError

  def self.unique_job!
    before_enqueue do
      throw :abort if SolidQueue::Job.joins(:ready_execution).where(concurrency_key:).any?
    end
  end
end
