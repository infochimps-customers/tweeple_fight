class Main
  include Rack::Utils
  helpers do
    def link_to_fight topic_a, topic_b
      qq = build_query :topic_a => topic_a, :topic_b => topic_b
      link_to "#{h topic_a} v #{h topic_b}", "/?#{qq}"
    end

    def twitter_profile_image user_hsh
      user_id     = user_hsh['user_id']
      screen_name = user_hsh['screen_name'] || user_hsh['user_id']
      haml_tag :img, :src => "http://api.twitter.com/1/users/profile_image/#{user_id}.png", :title => screen_name, :alt => "@#{screen_name}", :class => "twitter_user", :id => "twitter_user_#{user_id}"
    end
  end
end
