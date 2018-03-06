class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ChatChannel.connected_users(message.room) \
      .each do |user|
        ChatChannel.broadcast_to [message.room, user], message.to_broadcast_hash
      end
  end
end
