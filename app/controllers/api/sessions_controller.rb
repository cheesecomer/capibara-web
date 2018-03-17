class Api::SessionsController < Api::ApplicationController
  skip_before_action :authenticate_user_from_token!

  # POST /v1/login
  #   curl localhost:3000/api/session \
  #     --data '{ "email": "user@email.com", "password": "password" }' \
  #     --header "Content-type: application/json"
  #     or
  #   curl localhost:3000/api/session \
  #     --data '{ "provider": "twitter", "access_token": "xxxxxxx", "access_token_secret": "xxxxxxxxx" }' \
  #     --header "Content-type: application/json"
  def create
    if params[:email].present?
      find_by_email
    else
      find_or_create_by_oauth
    end
  end

  private

  def find_by_email
    @user = User.find_for_database_authentication(email: params[:email])
    invalid_email and return unless @user

    if @user.valid_password?(params[:password])
      @user.update_access_token!
      sign_in :user, @user
      render
    else
      invalid_password
    end
  end

  def find_or_create_by_oauth
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET_KEY"]
      config.access_token = params[:access_token]
      config.access_token_secret = params[:access_token_secret]
    end
    oauth_user = client.user

    @user = User.where(oauth_uid: oauth_user.id, oauth_provider: :twitter).first
    @user = User.create nickname: oauth_user.name, oauth_provider: :twitter, oauth_uid: oauth_user.id if @user.nil?

    @user.update \
      oauth_access_token: params[:access_token],
      oauth_access_token_secret: params[:access_token_secret]

    @user.update_access_token!
    sign_in :user, @user
    render
  end

  def invalid_email
    warden.custom_failure!
    render json: { message: t('devise.failure.invalid') }, status: :unauthorized
  end

  def invalid_password
    warden.custom_failure!
    render json: { message: t('devise.failure.invalid') }, status: :unauthorized
  end
end
