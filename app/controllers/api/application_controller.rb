# app/controllers/api/application_controller.rb
class Api::ApplicationController < ActionController::API
  include AbstractController::Translation

  before_action :authenticate_user_from_token!

  respond_to :json

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
