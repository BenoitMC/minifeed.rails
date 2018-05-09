class Feed::ImportAllService < Service
  POOL_SIZE = 10

  def call
    feeds.each do |feed|
      pool.post do
        Feed::ImportService.call(feed)
      end
    end

    pool.shutdown
    pool.wait_for_termination
  end

  private

  def feeds
    Feed.preload(:user, :category)
  end

  def pool
    @pool ||= Concurrent::FixedThreadPool.new(POOL_SIZE)
  end
end
