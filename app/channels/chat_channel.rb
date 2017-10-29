class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{self.channel_name}:#{params[:room_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
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
