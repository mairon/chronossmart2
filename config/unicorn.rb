# set path to application
worker_processes 2
listen 4000
timeout 4000

preload_app true

# config/unicorn.rb
before_fork do |server, worker|
  # other settings
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  # other settings
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
