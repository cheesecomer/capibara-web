
class Api::UsersController < Api::ApplicationController
  skip_before_action :authenticate_user_from_token!, only: [:create]

  # POST /users
  #   curl localhost:3000/api/users \
  #     --data '{ "nickname": "AAA" }' \
  #     -v -H "Accept: application/json" -H "Content-type: application/json"
  # Create an user
  def create
    @user = User.new user_create_params
    @user.is_api_request = true
    @user.save!
    render template: 'api/sessions/create'
  end

  def show
    @user = User.find params[:id]
  end

  def update
    @user = current_user
    @user.is_api_request = true
    @user.update! user_update_params
    render :show
  end

  def destroy
    current_user.destroy!
    head :no_content
  end

  private

  def user_create_params
    params.require(:user).permit(:nickname)
  end

  def user_update_params
    params.require(:user).permit(:nickname, :icon, :biography)
  end
end
