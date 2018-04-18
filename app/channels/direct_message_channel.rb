class DirectMessageChannel < ApplicationCable::Channel
  def subscribed
    addressee = User.find params[:addressee_id]
    stream_for [connection.current_user, addressee]
  end

  def unsubscribed
    stop_all_streams
  end

  def speak(data)
    data.deep_symbolize_keys!
    addressee = User.find params[:addressee_id]
    dm = DirectMessage.create! \
      content: data[:message],
      sender: connection.current_user,
      addressee: addressee

    # 自分の発言を自分のコネクションに流す
    DirectMessageChannel.broadcast_to [connection.current_user, addressee], dm.to_broadcast_hash

    # 自分の発言を相手のコネクションに流す
    DirectMessageChannel.broadcast_to [addressee, connection.current_user], dm.to_broadcast_hash if addressee.follow_users.exists? id: connection.current_user.id
  end
end
