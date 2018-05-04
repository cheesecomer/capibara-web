Rails.application.configure do
  config.eager_load = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
end