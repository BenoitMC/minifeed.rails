scheduler = Rufus::Scheduler.singleton

def scheduler.on_error(_job, error)
  Bugsnag.notify(error)
end

if Minifeed.config.autoimport_enabled
  rufus_interval = Minifeed.config.autoimport_interval.to_i.to_s + "s"

  scheduler.every rufus_interval, first_in: "30s", overlap: false do
    Feed::ImportAllService.call
  end
end
