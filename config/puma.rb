max_threads_count = ENV.fetch("PUMA_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("PUMA_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

workers ENV["PUMA_WORKERS"].to_i

preload_app!

if ENV["PUMA_BIND"].to_s.length > 0
  bind ENV["PUMA_BIND"]
elsif ENV["PUMA_PORT"].to_i > 0
  port ENV["PUMA_PORT"].to_i
end

environment ENV.fetch("RAILS_ENV") { "development" }

plugin :tmp_restart
plugin :solid_queue
