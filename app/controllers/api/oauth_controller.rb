class Api::OauthController < Api::ApplicationController
  skip_before_action :authenticate_user_from_token!
  def callback
    user = User.find_or_create_from_oauth(request.env['omniauth.auth'])
    redirect_to "com.cheesecomer.capibara://oauth?access_token=#{user.access_token}&id=#{user.id}"
  end
end