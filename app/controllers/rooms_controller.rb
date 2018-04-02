class RoomsController < ApplicationController
  layout 'admin'

  def index
    @rooms = Room.order :priority
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end
