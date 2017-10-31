
class Api::UsersController < Api::ApplicationController
  skip_before_action :authenticate_user_from_token!, only: [:create]

  # POST /users
  #   curl localhost:3000/api/users \
  #     --data '{ "nickname": "AAA" }' \
  #     -v -H "Accept: application/json" -H "Content-type: application/json"
  # Create an user
  def create
    @user = User.new user_params
    @user.is_api_request = true
    @user.save!
    render template: 'api/sessions/create'
  end

  def show
    @user = User.find params[:id]
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :nickname)
  end
end
