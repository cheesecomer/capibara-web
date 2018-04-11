class Api::InformationsController < Api::ApplicationController
  def index
    @informations = Information.published.order(published_at: :desc)
  end
end