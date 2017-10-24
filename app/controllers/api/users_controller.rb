
class Api::UsersController < Api::ApplicationController
  skip_before_action :authenticate_user_from_token!, only: [:create]

  # POST /users
  #   curl localhost:3000/api/users \
  #     --data '{ "nickname": "AAA" }' \
  #     -v -H "Accept: application/json" -H "Content-type: application/json"
  # Create an user
  def create
    @user = User.new user_params

    if @user.save
      render template: 'api/sessions/create'
    else
      render \
        json: { error: t('user_create_error') },
        status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :nickname)
  end
end
