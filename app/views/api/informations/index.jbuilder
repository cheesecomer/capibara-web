json.set! :informations do
  json.array! @informations do |information|
    json.set! :id, information.id
    json.set! :title, information.title
    json.set! :message, information.message
    json.set! :published_at, information.published_at
  end
end
