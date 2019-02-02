scheduler = Rufus::Scheduler.singleton

def scheduler.on_error(_job, error)
  Bugsnag.notify(error)
end

if Minifeed.config.autoimport_enabled
  scheduler.every "15s", first_in: "30s", overlap: false do
    Feed::ImportOutdatedService.call
  end
end
