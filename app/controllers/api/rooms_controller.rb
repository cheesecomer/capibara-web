class Api::RoomsController < Api::ApplicationController
  def index
    @rooms = Room.all
  end
end
