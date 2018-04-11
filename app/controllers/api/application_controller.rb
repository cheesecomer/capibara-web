# app/controllers/api/application_controller.rb
class Api::ApplicationController < ActionController::API
  include Rescue
  include ActionController::MimeResponds
  include AbstractController::Translation

  before_action :authenticate_user_from_token!
  before_action :verify_http_header!

  rescue_from Forbidden, with: :rescue403

  respond_to :json

  protected

  ##
  # User Authentication
  # Authenticates the user with OAuth2 Resource Owner Password Credentials
  def authenticate_user_from_token!
    auth_token = request.headers['Authorization']
    authenticate_error unless authenticate_with_auth_token auth_token
  end

  def verify_http_header!
    application_version = request.headers['HTTP_X_APPLICATIONVERSION']
    platform = request.headers['HTTP_X_PLATFORM']
    head :forbidden and return if BanDevice.where(device_id: request.headers['HTTP_X_DEVICEID'] || '').first.present?
    head :bad_request and return unless platform.present? && application_version.present?
    head :upgrade_required and return if Capibara::Application.config.application_versions[platform] > Gem::Version.new(application_version)
  end

  private

  def rescue403(e)
    request.format = :json if request.xhr?

    respond_to do |format|
      format.json {
        render \
          '/api/errors/forbidden',
          status: :forbidden }
    end
  end

  def authenticate_with_auth_token(auth_token)
    return unless auth_token

    access_token = auth_token.split(' ').last
    user = User.where(access_token: access_token).first

    if user
      # User can access
      sign_in user, store: false
      user.update last_device_id: request.headers['HTTP_X_DEVICEID']
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
