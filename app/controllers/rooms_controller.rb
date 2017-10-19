class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:id])
  end

  def index
    @rooms = Room.all
  end
end
