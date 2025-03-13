module Minifeed
  class Config
    attr_accessor(
      :refresh_feeds_after,
      :entries_per_page,
    )
  end

  cattr_accessor :config

  self.config = Config.new
end
