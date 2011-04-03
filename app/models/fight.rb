Fight = Struct.new(:topic_a, :topic_b) do
  BIEBER_UNIT     = 197071

  def self.from_hash hsh
    new(* hsh.values_at(*members))
  end

  def success?
    topic_a.present? && topic_b.present? &&
      result_a.present? && result_b.present? &&
      result_a['total'].present? && result_b['total'].present?
  end

  def empty?
    topic_a.blank? && topic_b.blank?
  end

  def result_a
    # @result_a ||= { 'total' => 100 }
    @result_a ||= infochimps_request 'social/network/tw/search/people_search', :q => topic_a
  end
  def result_b
    # @result_b ||= { 'total' => 100_00 }
    @result_b ||= infochimps_request 'social/network/tw/search/people_search', :q => topic_b
  end

  def winner
    [topic_a, topic_b][winner_idx]
  end
  def winner_idx
    (number_hits[0].to_i >= number_hits[1].to_i) ? 0 : 1
  end

  #
  # Result counts
  # 

  def number_hits
    [ result_a['total'], result_b['total'] ]
  end

  def micro_biebers
    number_hits.map{|hit| hit.is_a?(String) ? hit : (1_000_000.0 * hit.to_f / BIEBER_UNIT).round }
  end

  def bieberosity
    number_hits.map{|bb| 100 * Math.log10(bb) / Math.log10(BIEBER_UNIT) rescue -1 }
  end

  #
  # Result users
  #
  def users
    [ (result_a['results'] || []).select{|u| u.has_key?('name') }.sort_by{|u| u['id'] }[0..26],
      (result_b['results'] || []).select{|u| u.has_key?('name') }.sort_by{|u| u['id'] }[0..26],
    ]
  end

protected
  
  def conn
    @conn = Faraday.new(:url => 'http://api.infochimps.com') do |builder|
      builder.request   :url_encoded
      builder.request   :json
      builder.response  :logger
      builder.adapter   Main::FARADAY_ADAPTER
    end
  end

  def infochimps_request path, params
    params = params.merge :_apikey => Settings.infochimps_apikey
    p params
    resp = conn.get do |req|
      req.url     path
      req[:timeout] = 0.5
      params.each{|k,v| req.params[k] = v }
    end
    begin
      results = JSON.parse(resp.body) || {}
    rescue
      results = {}
    end
    results
  end

end

