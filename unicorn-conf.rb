#!/usr/bin/env ruby
app_dir = File.expand_path(File.dirname(__FILE__))
tmp_dir = "#{app_dir}/tmp" ; FileUtils.mkdir_p(tmp_dir)
log_dir = "#{app_dir}/log" ; FileUtils.mkdir_p(log_dir)

case ENV['RACK_ENV']
when 'development'
  worker_processes  2
  preload_app       false
  puts ENV['RACK_ENV']
else
  worker_processes  5
  preload_app       true
  stderr_path       "#{log_dir}/unicorn.stderr.log"
  stdout_path       "#{log_dir}/unicorn.stdout.log"
end

# # REE
GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

timeout             80
working_directory   app_dir
listen              "#{tmp_dir}/unicorn.sock", :backlog => 64
pid                 "#{tmp_dir}/unicorn.pid"

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  addr = "0.0.0.0:#{9000 + worker.nr}"
  # Try to connect every 5s -- an older daemon might still be quitting and own the port
  server.listen(addr, :tries => -1, :delay => 5, :backlog => 64)
end
