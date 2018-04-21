json.set! :threads do
  json.array! @direct_messages.order(created_at: :desc, id: :desc) do |direct_message|
    follow = direct_message.follows.take
    json.set! :user do
      json.set! :id, follow.target.id
      json.set! :icon_thumb_url, follow.target.icon_url(:thumb)
      json.set! :nickname, follow.target.nickname
    end
    json.set! :latest_direct_message do
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
end
