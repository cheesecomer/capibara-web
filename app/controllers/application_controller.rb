class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_admin!
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :rescue404

  def rescue404(e)
    request.format = :json if request.xhr?

    render 'errors/not_found', status: :not_found
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:nickname, :email, :password, :password_confirmation)
    end
  end
end
