class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{self.channel_name}:#{params[:room_id]}"
    ChatChannel.broadcast_to \
      params[:room_id],
      id: 0,
      content: {
        type: :join_user,
        user: { id: connection.current_user.id, nickname: connection.current_user.nickname },
        number_of_participants: ChatChannel.connected_users_count(Room.find params[:room_id])
      }.to_json,
      at: Time.zone.now
  end

  def unsubscribed
    ChatChannel.broadcast_to \
      params[:room_id],
      id: 0,
      content: {
        type: :join_user,
        user: { id: connection.current_user.id, nickname: connection.current_user.nickname },
        number_of_participants: ChatChannel.connected_users_count(Room.find params[:room_id])
      }.to_json,
      at: Time.zone.now
  end

  def speak(data)
    data.deep_symbolize_keys!
    Message.create! \
      content: data[:message],
      sender: connection.current_user,
      room_id: params[:room_id]
  end

  def self.connected_users(room)
    ApplicationCable::Connection.connected_users do |h|
      h[:channel] == ChatChannel.name && h[:room_id] == room.id
    end
  end

  def self.connected_users_count(room)
    ApplicationCable::Connection.connected_users_count do |h|
      h[:channel] == ChatChannel.name && h[:room_id] == room.id
    end
  end
end
