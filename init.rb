require File.expand_path(File.join(File.dirname(__FILE__), 'lib/boot'))

# Generic app components
require 'app_main'
require 'app_compass'
require 'app_api_client'

# For this app

[
  Dir[Main.root_path("app/models/*.rb")],
  Dir[Main.root_path("app/routes/*.rb")],
  Dir[Main.root_path("app/helpers/*.rb")],
  Dir[Main.root_path("app/rack/*.rb")],
].flatten.each do |file| require file end

# Include middleware
Main.class_eval do
  set :app_file, __FILE__
  set :run,      Proc.new{ $0 == app_file }
  use Rack::Heartbeat
end

