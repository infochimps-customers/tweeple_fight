Fight = Struct.new(:topic_a, :topic_b, :result_a, :result_b) do

  def self.from_hash hsh
    new(* hsh.values_at(*members))
  end

  def fetch!
    # self.result_a = infochimps_request 'social/network/tw/search/people_search', :q => topic_a
    # self.result_b = infochimps_request 'social/network/tw/search/people_search', :q => topic_b
  end

  def number_hits
    # [result_a['total'], result_b['total']]
    [9, 197071]
  end


protected
  
  def conn
    @conn = Faraday.new(:url => 'http://api.infochimps.com') do |builder|
      builder.request   :url_encoded
      builder.request   :json
      builder.response  :logger
      builder.adapter   :net_http
    end
  end

  def infochimps_request path, params
    params = params.merge :_apikey => Settings.infochimps_apikey
    p params
    resp = conn.get do |req|
      req.url path
      params.each{|k,v| req.params[k] = v }
    end
    begin
      results = JSON.parse(resp.body)
    rescue
      results = {}
    end
    results
  end

end

