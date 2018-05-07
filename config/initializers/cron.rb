scheduler = Rufus::Scheduler.singleton

scheduler.every "5m", first: :now, overlap: false do
  Feed::ImportAllService.call
end
