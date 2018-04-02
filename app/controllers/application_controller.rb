class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_admin!
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  rescue_from ActiveRecord::RecordInvalid, with: :rescue422
  rescue_from ActiveModel::ValidationError, with: :rescue422

  layout 'public'

  protected

  def rescue404(e)
    request.format = :json if request.xhr?

    render 'errors/not_found', status: :not_found
  end

  def rescue422(e)
    request.format = :json if request.xhr?

    errors = []
    errors = e.record.errors if e.is_a?(ActiveRecord::RecordInvalid)
    errors = e.model.errors  if e.is_a?(ActiveModel::ValidationError)

    respond_to do |format|
      format.json { render_unprocessable_entity(errors) }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:nickname, :email, :password, :password_confirmation)
    end
  end

  def render_unprocessable_entity(errors)
    render \
      '/api/errors/unprocessable_entity',
      locals: { errors: errors },
      status: :unprocessable_entity
  end
end
