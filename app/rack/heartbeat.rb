module Rack
  # A heartbeat mechanism for the server. This will add a meta/status endpoint
  # that returns status 200 and content OK when executed.
  #
  # @example
  #  use Rack::Heartbeat
  #
  class Heartbeat
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['PATH_INFO'] == '/meta/status'
        [200, {"Content-Type" => "text/html"}, ['OK']]
      else
        @app.call(env)
      end
    end
  end
end
