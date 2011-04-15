class ::Main < Sinatra::Base

  get "/" do
    @fight = Fight.from_hash(params)
    @dump = [ params, @fight.number_hits, @fight, ] # @fight.result_a
    headers['Cache-Control'] = ''
    headers['X-YYYY'] = 'graph'
    haml :root
  end

  # Debug
  get %r{^/debug/?} do
    haml :debug
  end

  # get "/*" do
  #   response.headers['Cache-Control'] = 'public, max-age=3600'
  #   response.headers['XXX'] = 'public, max-age=3600'
  #   p ['*************', response.headers, params[:splat]]
  #   send_file(Main.root_path('public', params[:splat]), :disposition => nil)
  # end
end
