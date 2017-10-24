class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "#{self.channel_name}:#{params[:room_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create! \
      content: data['message'],
      sender: current_user,
      room_id: params[:room_id]
  end

  def self.connected_user(room)
    ApplicationCable::Connection.connected_user do |h|
      h[:channel] == ChatChannel.name && h[:room_id] == room.id
    end
  end
end
