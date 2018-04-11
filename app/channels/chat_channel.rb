class ChatChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find params[:room_id]
    connected_users_count = ChatChannel.connected_users_count room
    if connected_users_count >= room.capacity
      reject_subscription
      return
    end
    stream_for room
    stream_for [room, connection.current_user]
    ChatChannel.broadcast_to room, join_user_message
  end

  def unsubscribed
    room = Room.find params[:room_id]
    ChatChannel.broadcast_to room, leave_user_message
    stop_all_streams
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

  protected

  def join_state_message(type)
    {
      id: 0,
      content: {
        type: type,
        user: connection.current_user.to_broadcast_hash,
        number_of_participants: ChatChannel.connected_users_count(Room.find(params[:room_id]))
      }.to_json,
      at: Time.zone.now
    }
  end

  def join_user_message
    join_state_message :join_user
  end

  def leave_user_message
    join_state_message :leave_user
  end
end
