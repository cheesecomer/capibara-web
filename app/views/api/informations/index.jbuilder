json.set! :informations do
  json.array! @informations do |information|
    json.extract! information, :id, :title, :message, :published_at
    json.set! :url, information_url(information)
  end
end
