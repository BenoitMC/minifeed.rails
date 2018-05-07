scheduler = Rufus::Scheduler.singleton

if defined?(Rails::Server)
  scheduler.every "5m", first: :now, overlap: false do
    Feed::ImportAllService.call
  end
end
