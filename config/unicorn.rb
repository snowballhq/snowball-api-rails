if ENV['UNICORN_COUNT'].to_i > 0
  worker_processes ENV['UNICORN_COUNT'].to_i
else
  worker_processes 4
end
timeout 30
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    logger.info 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    logger.info 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
