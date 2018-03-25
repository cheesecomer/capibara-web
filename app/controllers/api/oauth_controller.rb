class Api::OauthController < Api::ApplicationController
  skip_before_action :authenticate_user_from_token!
  skip_before_action :verify_http_header!
  def callback
    user = User.find_or_create_from_oauth(request.env['omniauth.auth'])
    redirect_to "com.cheesecomer.capibara://oauth?access_token=#{user.access_token}&id=#{user.id}"
  end
end