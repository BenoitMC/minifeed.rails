Minifeed.config.tap do |c|
  c.autoimport_enabled   = Rails.env.production?
  c.autoimport_pool_size = Concurrent.processor_count*2
  c.refresh_feeds_after  = 5.minutes
  c.entries_per_page     = 100
end
