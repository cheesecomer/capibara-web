json.set! :follows do
  json.array! @follows do |follow|
    json.set! :id, follow.id
    json.set! :target do
      json.set! :id, follow.target.id
      json.set! :icon_thumb_url, follow.target.icon_url(:thumb)
      json.set! :nickname, follow.target.nickname
    end
  end
end
