class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{self.channel_name}:#{params[:room_id]}"
    ChatChannel.broadcast_to params[:room_id], join_user_message
  end

  def unsubscribed
    ChatChannel.broadcast_to params[:room_id], leave_user_message
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

  def room
    Room.find params[:room_id]
  end

  def join_state_message(type)
    {
      id: 0,
      content: {
        type: type,
        user: connection.current_user.to_broadcast_hash,
        number_of_participants: ChatChannel.connected_users_count(room)
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
