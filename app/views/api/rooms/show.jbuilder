json.set! :id, @room.id
json.set! :name, @room.name
json.set! :capacity, @room.capacity
json.set! :number_of_participants, ChatChannel.connected_users_count(@room)
json.set! :participants do
  json.array! ChatChannel.connected_users(@room) do |user|
    json.set! :id, user.id
    json.set! :name, user.name
  end
end
