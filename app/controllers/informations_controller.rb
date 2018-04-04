class InformationsController < ApplicationController
  skip_before_action :authenticate_admin!, only: %i[show]
  def index
    @informations = Information.order(published_at: :desc)
    render layout: 'admin'
  end

  def new; end

  def show
    @information = Information.find(params[:id])
    raise ActiveRecord::RecordNotFound if current_admin.nil? && !@information.published?
  end
end