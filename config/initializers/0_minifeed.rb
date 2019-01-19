Minifeed.config.tap do |c|
  c.autoimport_enabled  = Module.const_defined?("Rails::Server")
  c.autoimport_enabled  = false
  c.autoimport_interval = 5.minutes
  c.entries_per_page    = 100
end
