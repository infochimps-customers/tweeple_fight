class ::Main < Sinatra::Base

  get "/" do
    @thingy = Thingy.from_hash(params[:thingy]||{})
    @dump = [ params, ]
    haml :root
  end

  # Debug
  get %r{^/debug/?} do
    haml :debug
  end
end
