require "compass"
require 'ninesixty'
require 'html5-boilerplate'

module Sinatra
  module Compass

    module ClassMethods
      attr_reader :compass_route, :compass_prefix
      def get_compass(path, &block)
        path.sub! /^\//, ''
        block ||= Proc.new do |file|
          content_type 'text/css', :charset => 'utf-8'
          compass :"#{path}/#{params[:name]}"
        end
        @compass_prefix = "/#{path}"
        @compass_route.deactivate if @compass_route
        @compass_route = get("/#{path}/:name.css", &block)
      end
    end

    module InstanceMethods
      def compass(file, options = {})
        options.merge! ::Compass.sass_engine_options
        sass file, options
      end

      def stylesheet(name)
        File.join(settings.compass_prefix, "#{name}.css")
      end
    end

    def self.registered(klass)
      klass.extend ClassMethods
      klass.send :include, InstanceMethods
      klass.set( :compass,
        :project_path  => klass.root_path,
        :output_style  => (klass.development? ? :expanded : :compressed),
        :sass_dir      => klass.root_path("views/stylesheets"),
        :root_dir      => klass.root_path,
        :line_comments => klass.development?)
      klass.get_compass("stylesheets")
    end

    def self.set_compass(klass)
      ::Compass.configuration do |config|
        config.sass_options ||= {}
        klass.compass.each do |option, value|
          if config.respond_to? option
            config.send "#{option}=", value
          else
            config.sass_options.merge! option.to_sym => value
          end
        end
      end
    end

  end
end

Main.class_eval do
  register ::Sinatra::Compass
end

