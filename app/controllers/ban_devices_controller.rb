class BanDevicesController < ApplicationController
  def create
    BanDevice.create! create_params
    head :ok
  end

  private
  def create_params
    params.require(:ban_device).permit(:device_id)
  end
end
