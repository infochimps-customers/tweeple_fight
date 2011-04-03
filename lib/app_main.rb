require 'gorillib'
require 'gorillib/logger/log'
require 'gorillib/hash/keys'
require 'gorillib/string/inflections'
require 'gorillib/string/human'
require 'configliere'
#
require "sinatra/base"
#
require 'tilt'
require 'RedCloth'
require 'haml'
Tilt.register :haml, Tilt[:haml]
# require 'erubis'
# Tilt.register :erb,  Tilt[:erubis]


#
# App Settings
#
Settings.define :logging,  :description => "Should Sinatra output a log line as well", :type => :boolean
Settings.define :app_name, :description => "Name for this app"
Settings.define :google_api_key,    :description => "Google API key for fast jQuery retrieval", :env_var => 'GOOGLE_API_KEY'
Settings.define :google_account_id, :description => "Google account ID for google analytics",   :env_var => 'GOOGLE_ACCOUNT_ID'
Settings.define :infochimps_apikey, :description => "API key for infochimps.com. See http://infochimps.com/apis if you're ready for the awesomeness", :env_var => 'INFOCHIMPS_APIKEY'
Settings.read("#{::ROOT_DIR}/config/main.yaml",         :env => ENV['RACK_ENV'])
Settings.read("#{::ROOT_DIR}/config/main-private.yaml", :env => ENV['RACK_ENV'])
Settings.resolve!


class Main < Sinatra::Base
  def self.root_path(*args)
    File.join(::ROOT_DIR, *args)
  end

  def self.staging?()  environment == :staging  end
  def self.heroku?()   !!ENV['HEROKU'] ; end
  set :root,             Main.root_path
  set :views,            Main.root_path("app", "views")
  set :dump_errors,      Proc.new{ not (development? || test?) }
  set :raise_errors,     Proc.new{ test? }
  set :show_exceptions,  Proc.new{ development? }
  set :static,           Proc.new{ development? || test? || heroku? }
  set :clean_trace,      Proc.new{ development? || test? }
  set :logging,          true

  require 'rack-flash'
  enable :sessions
  use Rack::Flash

  helpers do
    def haml(template, options = {}, locals = {})
      options[:escape_html] = true unless options.include?(:escape_html)
      super(template, options, locals)
    end

    def partial(template, locals = {})
      template = "_#{template}".to_sym
      haml(template, {:layout => false}, locals)
    end

    %w[environment production? development? test? staging? heroku? ].each do |meth|
      define_method(meth) { |*a| self.class.send(meth, *a) }
    end
  end
end

