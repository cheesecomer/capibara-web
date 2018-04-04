class InformationsController < ApplicationController
  skip_before_action :authenticate_admin!, only: %i[show]
  def index
    @informations = Information.order(published_at: :desc)
    render layout: 'admin'
  end

  def new; end

  def create
    @information = Information.create! create_or_update_params
    head :ok
  end

  def show
    @information = Information.find(params[:id])
    raise ActiveRecord::RecordNotFound if current_admin.nil? && !@information.published?
  end

  private
  def create_or_update_params
    params.require(:information).permit(:title, :message, :content, :published_at)
  end
end