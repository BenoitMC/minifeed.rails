if Rails.env.development? || Rails.env.test?
  Sprockets.export_concurrent = false
end
