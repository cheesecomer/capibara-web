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
  json.array! @room.messages.includes(:sender).where(created_at: 10.minutes.ago..10.minutes.since).last(20) do |message|
    json.set! :sender do
      json.set! :id, message.sender.id
      json.set! :nickname, message.sender.nickname
    end
    json.set! :id, message.id
    json.set! :content, message.content
    json.set! :at, message.created_at
  end
end