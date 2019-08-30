module Minifeed
  class Config
    attr_accessor(
      :autoimport_enabled,
      :autoimport_pool_size,
      :refresh_feeds_after,
      :entries_per_page,
    )
  end

  cattr_accessor :config

  self.config = Config.new
end
