class Api::BlocksController < Api::ApplicationController
  def index
    @blocks = Block.where(owner: current_user)
  end
end