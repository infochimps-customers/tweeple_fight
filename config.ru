require "./init"
require 'rack/contrib/response_headers'

use Rack::ResponseHeaders do |headers|
  headers['Cache-Control'] ||= 'public, max-age=3600'
  headers['X-XXX'] = 'for porn'
end

Main.set :run, false
run Main
