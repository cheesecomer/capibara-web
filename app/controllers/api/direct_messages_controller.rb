class Api::DirectMessagesController < Api::ApplicationController
  def index
    @direct_messages =
      DirectMessage.includes(:follows).references(:follows)
        .where(follows: { owner: current_user })
        .preload(:sender, follows: :target)
  end

  def show
    target = User.find(params[:id])
    last_id = params[:last_id]&.to_i
    @direct_messages =
      DirectMessage.where(sender: current_user, addressee: target)
        .or(DirectMessage.where(sender: target, addressee: current_user))

    @direct_messages = @direct_messages.where(id: -Float::INFINITY...last_id) if last_id.present?
  end
end