# app/controllers/api/application_controller.rb
class Api::ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include AbstractController::Translation

  before_action :authenticate_user_from_token!

  rescue_from ActiveRecord::RecordInvalid, with: :rescue422
  rescue_from ActiveModel::ValidationError, with: :rescue422
  rescue_from Forbidden, with: :rescue403

  respond_to :json

  protected

  def rescue422(e)
    request.format = :json if request.xhr?

    errors = []
    errors = e.record.errors if e.is_a?(ActiveRecord::RecordInvalid)
    errors = e.model.errors  if e.is_a?(ActiveModel::ValidationError)

    respond_to do |format|
      format.json { render_unprocessable_entity(errors) }
    end
  end

  def rescue403(e)
    request.format = :json if request.xhr?

    respond_to do |format|
      format.json {
        render \
          '/api/errors/forbidden',
          status: :forbidden }
    end
  end

  def render_unprocessable_entity(errors)
    render \
      '/api/errors/unprocessable_entity',
      locals: { errors: errors },
      status: :unprocessable_entity
  end

  ##
  # User Authentication
  # Authenticates the user with OAuth2 Resource Owner Password Credentials
  def authenticate_user_from_token!
    auth_token = request.headers['Authorization']
    authenticate_error unless authenticate_with_auth_token auth_token
  end

  private

  def authenticate_with_auth_token(auth_token)
    return unless auth_token

    access_token = auth_token.split(' ').last
    user = User.where(access_token: access_token).first

    if user
      # User can access
      sign_in user, store: false
      true
    else
      false
    end
  end

  ##
  # Authentication Failure
  # Renders a 401 error
  def authenticate_error
    render \
      json: { message: t('devise.failure.unauthenticated') },
      status: :unauthorized
  end
end
