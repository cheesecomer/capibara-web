class InformationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  def show
    @information = Information.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @information.published?
  end
end