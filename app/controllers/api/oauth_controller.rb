class Api::OauthController < Api::ApplicationController
  skip_before_action :authenticate_user_from_token!
  skip_before_action :verify_http_header!
  def callback
    user_id = request.env['omniauth.params']['user_id']
    access_token = request.env['omniauth.params']['access_token']

    user = User.where(id: user_id, access_token: access_token).first if user_id.present?

    # おめーの席ねぇから！
    raise Forbidden if user_id.present? && user.nil?

    if user.present?
      user.update_oauth! request.env['omniauth.auth']
    else
      user = User.find_or_create_from_oauth(request.env['omniauth.auth'])
    end

    redirect_to "com.cheesecomer.capibara://oauth?access_token=#{user.access_token}&id=#{user.id}"
  end
end