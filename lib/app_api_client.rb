require 'yajl/json_gem'
require 'faraday'

#
# Choose your faraday adapter
#

# # EM-synchrony, with asynchronous rack support. Modify the Gemfile too
# require 'async-rack'
# require 'rack/fiber_pool'
# Main.class_eval do
#   use Rack::FiberPool
#   FARADAY_ADAPTER = :em_synchrony
# end

# typhoeus
Main::FARADAY_ADAPTER = :typhoeus

# or you can just use Net::HTTP
# Main::FARADAY_ADAPTER = :net_http
