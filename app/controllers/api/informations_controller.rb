class Api::InformationsController < Api::ApplicationController
  def index
    @informations = Information.published
  end
end