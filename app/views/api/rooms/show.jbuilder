json.set! :id, @room.id
json.set! :name, @room.name
json.set! :capacity, @room.capacity
json.set! :number_of_participants, ChatChannel.connected_users_count(@room)
json.set! :participants do
  json.array! ChatChannel.connected_users(@room) do |user|
    json.set! :id, user.id
    json.set! :nickname, user.nickname
  end
end
json.set! :messages do
  json.array! @room.messages.where.not(sender_id: Block.where(target: current_user).pluck(:owner_id) + Block.where(owner: current_user).pluck(:target_id)).includes(:sender).last(20) do |message|
    json.set! :sender do
      json.set! :id, message.sender.id
      json.set! :nickname, message.sender.nickname
      json.set! :icon_url, message.sender.icon_url
    end unless message.sender.nil?
    json.set! :sender, nil if message.sender.nil?
    json.set! :id, message.id
    json.set! :content, message.content
    json.set! :at, message.created_at
  end
end
