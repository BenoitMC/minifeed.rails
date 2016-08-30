# https://github.com/ariya/phantomjs/issues/13677

module RackETagDisable
  def call(env)
    @app.call(env)
  end
end

Rack::ETag.send(:prepend, RackETagDisable)
