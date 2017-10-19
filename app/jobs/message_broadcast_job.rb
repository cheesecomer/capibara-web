class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ChatChannel.broadcast_to message.room_id, message.to_broadcast_hash
  end
end
