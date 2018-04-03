class RoomsController < ApplicationController
  layout 'admin'

  def index
    @rooms = Room.order :priority
  end

  def new
    render layout: false
  end

  def create
    @room = Room.create! create_params
    head :ok
  end

  def update
  end

  def destroy
  end

  private
  def create_params
    params.require(:room).permit(:name, :capacity, :priority)
  end
end
