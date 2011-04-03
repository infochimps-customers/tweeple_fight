class Main
  include Rack::Utils
  helpers do
    def link_to_fight topic_a, topic_b
      qq = build_query :topic_a => topic_a, :topic_b => topic_b
      link_to "#{h topic_a} v #{h topic_b}", "/?#{qq}"
    end
  end
end
