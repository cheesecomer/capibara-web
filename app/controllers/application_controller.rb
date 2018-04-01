class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :rescue404

  def rescue404(e)
    request.format = :json if request.xhr?

    render 'errors/not_found', status: :not_found
  end
end
