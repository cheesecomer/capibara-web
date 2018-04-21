class Api::DirectMessagesController < Api::ApplicationController
  def index
    @direct_messages =
      DirectMessage.joins(:follows)
        .where(follows: { owner_id: current_user })
        .order(created_at: :desc, id: :desc)
  end

  def show
  end
end