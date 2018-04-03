class RoomsController < ApplicationController
  layout 'admin'

  def index
    @rooms = Room.order :priority
  end

  def edit
    @room = Room.find(params[:id])
    render layout: false
  end

  def new
    render layout: false
  end

  def create
    @room = Room.create! create_or_update_params
    head :ok
  end

  def update
    Room.find(params[:id]).update! create_or_update_params
    head :ok
  end

  def destroy
  end

  private
  def create_or_update_params
    params.require(:room).permit(:name, :capacity, :priority)
  end
end
