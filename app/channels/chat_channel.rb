class ChatChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find params[:room_id]
    connected_users_count = room.participants.count
    if connected_users_count >= room.capacity
      reject_subscription
      return
    end

    connection.group_identifier = params[:room_id]

    stream_for room
    stream_for [room, connection.current_user]
    ChatChannel.broadcast room, connection.current_user, join_user_message
  end

  def unsubscribed
    ChatChannel.broadcast Room.find(params[:room_id]), connection.current_user, leave_user_message
    stop_all_streams
  end

  def speak(data)
    data.deep_symbolize_keys!
    message = Message.create!(
      content: data[:message],
      image: data[:image],
      sender: connection.current_user,
      room_id: params[:room_id])
    block_user_ids = []
    block_user_ids += Block.where(owner: connection.current_user).map{|v| v.target_id }
    block_user_ids += Block.where(target: connection.current_user).map{|v| v.owner_id }
    message.room.participants.select {|v| !block_user_ids.include?(v.id) }.each do |user|
      ChatChannel.broadcast_to [message.room, user], message.to_broadcast_hash
    end
  end

  protected

  def join_state_message(type)
    {
      id: 0,
      content: {
        type: type,
        user: connection.current_user.to_broadcast_hash,
        number_of_participants: Room.find(params[:room_id]).participants.count
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

  def self.broadcast(room, sender, message)
    block_user_ids = []
    block_user_ids += Block.where(owner: sender).map{|v| v.target_id }
    block_user_ids += Block.where(target: sender).map{|v| v.owner_id }
    room.participants.select {|v| !block_user_ids.include?(v.id) }.each do |user|
        ChatChannel.broadcast_to [room, user], message
      end
  end
end
