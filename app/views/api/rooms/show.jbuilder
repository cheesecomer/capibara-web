json.set! :id, @room.id
json.set! :name, @room.name
json.set! :capacity, @room.capacity
json.set! :number_of_participants, ChatChannel.connected_users_count(@room)
json.set! :participants do
  json.array! ChatChannel.connected_users(@room) do |user|
    json.set! :id, user.id
    json.set! :nickname, user.nickname
    json.set! :icon_url, user.icon_url
    json.set! :icon_thumb_url, user.icon_url(:thumb)
  end
end
json.set! :messages do
  json.array! @room.messages.where.not(sender_id: Block.where(target: current_user).pluck(:owner_id) + Block.where(owner: current_user).pluck(:target_id)).includes(:sender).where(created_at: 10.minutes.ago..10.minutes.since).last(10) do |message|
    json.set! :sender do
      json.set! :id, message.sender.id
      json.set! :nickname, message.sender.nickname
      json.set! :icon_url, message.sender.icon_url
      json.set! :icon_thumb_url, message.sender.icon_url(:thumb)
    end unless message.sender.nil?
    json.set! :sender, nil if message.sender.nil?
    json.set! :id, message.id
    json.set! :content, message.content
    json.set! :image_url, message.image_url
    json.set! :image_thumb_url, message.image_url(:thumb)
    json.set! :at, message.created_at
  end
end
