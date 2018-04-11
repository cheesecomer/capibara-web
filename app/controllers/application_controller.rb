class ApplicationController < ActionController::Base
  include Rescue

  before_action :authenticate_admin!
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :rescue404

  layout 'public'

  private

  def rescue404(e)
    request.format = :json if request.xhr?

    render 'errors/not_found', status: :not_found
  end
end
