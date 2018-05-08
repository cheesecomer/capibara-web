json.set! :direct_messages do
  json.array! @direct_messages.includes(:sender).last(50) do |direct_message|
    json.set! :sender do
      json.set! :id, direct_message.sender.id
      json.set! :nickname, direct_message.sender.nickname
      json.set! :icon_url, direct_message.sender.icon_url
      json.set! :icon_thumb_url, direct_message.sender.icon_url(:thumb)
    end
    json.set! :id, direct_message.id
    json.set! :content, direct_message.content
    json.set! :at, direct_message.created_at
  end
end
