Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = '/api/oauth'
  end
  provider :twitter, ENV["TWITTER_CONSUMER_KEY"], ENV["TWITTER_CONSUMER_SECRET_KEY"]
  provider :line, ENV["LINE_CHANNEL_ID"], ENV["LINE_CHANNEL_ID_SECRET"]
end