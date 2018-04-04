class RoomsController < ApplicationController
  layout 'admin'
  before_action only: [:show, :edit, :update, :destroy] do
    @room = Room.find(params[:id])
  end

  def index
    @rooms = Room.order :priority
  end

  def new; end

  def edit; end

  def create
    @room = Room.create! create_or_update_params
    head :ok
  end

  def update
    @room.update! create_or_update_params
    head :ok
  end

  def destroy
    @room.destroy
    head :no_content
  end

  private
  def create_or_update_params
    params.require(:room).permit(:name, :capacity, :priority)
  end
end
