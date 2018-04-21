json.set! :threads do
  json.array! @direct_messages.order(created_at: :desc, id: :desc) do |direct_message|
    json.set! :content, direct_message.content
    json.set! :at, direct_message.created_at
    follow = direct_message.follows.take
    json.set! :user do
      json.set! :id, follow.target.id
      json.set! :icon_thumb_url, follow.target.icon_url(:thumb)
      json.set! :nickname, follow.target.nickname
    end
  end
end
