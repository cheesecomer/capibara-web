class Api::BlocksController < Api::ApplicationController
  def index
    @blocks = Block.where(owner: current_user)
  end

  def create
    Block.create! create_params.merge(owner: current_user)
    @blocks = Block.where(owner: current_user)
    render :index
  end

  def destroy
    block = Block.find params[:id]
    raise Forbidden if block.owner != current_user
    block.destroy!
  end

  def create_params
    params.require(:block).permit(:target_id)
  end
end