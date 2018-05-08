scheduler = Rufus::Scheduler.singleton

if ENV["MINIFEED_AUTOIMPORT"].to_s == "true"
  scheduler.every "5m", first: :now, overlap: false do
    Feed::ImportAllService.call
  end
end
