json.set! :rooms do
  json.array! @rooms do |room|
    json.set! :id, room.id
    json.set! :name, room.name
    json.set! :capacity, room.capacity
    json.set! :number_of_participants, room.participants.size
  end
end
