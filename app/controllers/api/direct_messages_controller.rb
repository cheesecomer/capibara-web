class Api::DirectMessagesController < Api::ApplicationController
  def index
    @messages = DirectMessage.where(sender: user).or(DirectMessage.where(sender: user))
  end

  def show
  end
end