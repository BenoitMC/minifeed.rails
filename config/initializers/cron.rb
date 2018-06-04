scheduler = Rufus::Scheduler.singleton

def scheduler.on_error(_job, error)
  Bugsnag.notify(error)
end

if ENV["MINIFEED_AUTOIMPORT"].to_s == "true"
  scheduler.every "5m", first_in: "30s", overlap: false do
    Feed::ImportAllService.call
  end
end
