class ::Main < Sinatra::Base

  get "/" do
    @fight = Fight.from_hash(params)
    @dump = [ params, @fight.number_hits, @fight, ]
    headers['Cache-Control'] = 'public, max-age=600'
    haml :root
  end

  # Debug
  get %r{^/debug/?} do
    haml :debug
  end
end
