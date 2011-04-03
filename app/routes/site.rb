class ::Main < Sinatra::Base

  get "/" do
    @fight = Fight.from_hash(params)
    @dump = [ params, @fight.number_hits, @fight ]
    haml :root
  end

  # Debug
  get %r{^/debug/?} do
    haml :debug
  end
end
