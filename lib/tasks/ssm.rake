namespace :ssm do
  desc "Deploy SMM parameters to environment variable"
  task :deploy_parameters do
    encrypted_parameter_mapping = {
      "#{ENV['SSM_PARAMETER_PREFIX']}.app.secret_key_base": 'SECRET_KEY_BASE',
      "#{ENV['SSM_PARAMETER_PREFIX']}.redis.url": 'REDIS_URL',
      "#{ENV['SSM_PARAMETER_PREFIX']}.database.url": 'DATABASE_URL',
      "#{ENV['SSM_PARAMETER_PREFIX']}.oauth.line.key": 'LINE_CHANNEL_ID',
      "#{ENV['SSM_PARAMETER_PREFIX']}.oauth.line.secret": 'LINE_CHANNEL_ID_SECRET',
      "#{ENV['SSM_PARAMETER_PREFIX']}.oauth.google.key": 'GOOGLE_CLIENT_ID',
      "#{ENV['SSM_PARAMETER_PREFIX']}.oauth.google.secret": 'GOOGLE_CLIENT_SECRET',
      "#{ENV['SSM_PARAMETER_PREFIX']}.oauth.twitter.key": 'TWITTER_CONSUMER_KEY',
      "#{ENV['SSM_PARAMETER_PREFIX']}.oauth.twitter.secret": 'TWITTER_CONSUMER_SECRET_KEY'
    }

    params = JSON.parse `aws ssm get-parameters --name #{encrypted_parameter_mapping.keys.join(' ')} --with-decryption`
    params.deep_symbolize_keys[:Parameters].map {|v| [v[:Name], v[:Value]] }.each {|k, v| puts "export #{encrypted_parameter_mapping[k.to_sym]}=#{v}" }
  end
end
