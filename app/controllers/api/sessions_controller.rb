class Api::SessionsController < Api::ApplicationController
  skip_before_action :authenticate_user_from_token!

  # POST /v1/login
  # curl localhost:3000/api/session --data 'email=user@example.com&password=mypass'
  def create
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

  private

  def invalid_email
    warden.custom_failure!
    render json: { error: t('invalid_email') }
  end

  def invalid_password
    warden.custom_failure!
    render json: { error: t('invalid_password') }
  end
end