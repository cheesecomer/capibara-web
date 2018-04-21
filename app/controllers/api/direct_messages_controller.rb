class Api::DirectMessagesController < Api::ApplicationController
  def index
    @direct_messages =
      DirectMessage.joins(:follows)
        .where(follows: { owner_id: current_user })
        .order(created_at: :desc, id: :desc)
  end

  def show
    target = User.find(params[:id])
    @direct_messages =
      DirectMessage.where(sender: current_user, addressee: target)
        .or(DirectMessage.where(sender: target, addressee: current_user))
        .order(created_at: :desc, id: :desc)
  end
end