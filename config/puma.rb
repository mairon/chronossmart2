# config/puma.rb
threads 4,4
workers 2
preload_app!


# Default to production
rails_env = ENV['RAILS_ENV'] || "development"
environment rails_env

# config/puma.rb
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

