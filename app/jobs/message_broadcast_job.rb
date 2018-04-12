class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    users = ChatChannel.connected_users(message.room).map{|v| v };
    block_user_ids = []
    block_user_ids += Block.where(owner: message.sender, target: users).map{|v| v.target_id }
    block_user_ids += Block.where(owner: users, target: message.sender).map{|v| v.owner_id }
    users.select {|v| !block_user_ids.include?(v.id)}
      .each do |user|
        ChatChannel.broadcast_to [message.room, user], message.to_broadcast_hash
      end
  end
end
