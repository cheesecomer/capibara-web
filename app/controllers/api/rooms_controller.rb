class Api::RoomsController < Api::ApplicationController
  def index
    @rooms = Room.all.order(:priority)
  end

  def show
    @room = Room.find params[:id]
  end
end
