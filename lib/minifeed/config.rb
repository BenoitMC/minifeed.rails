module Minifeed
  class Config
    attr_accessor(
      :autoimport_enabled,
      :autoimport_interval,
      :entries_per_page,
    )
  end

  cattr_accessor :config

  self.config = Config.new
end
