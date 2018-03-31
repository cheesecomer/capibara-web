
CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_S3_ACCESS_KEY'],
    aws_secret_access_key: ENV['AWS_S3_SECRET_KEY'],
    region: 'ap-northeast-1'
  }

  config.fog_directory  = 'capibara'
  config.cache_storage = :fog
end