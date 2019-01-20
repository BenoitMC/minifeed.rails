Minifeed.config.tap do |c|
  c.autoimport_enabled  = Rails.env.production?
  c.autoimport_interval = 5.minutes
  c.entries_per_page    = 100
end
