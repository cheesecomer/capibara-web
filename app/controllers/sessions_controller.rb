class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    super
  end

  def create
    super
  end

  def after_sign_in_path_for(_resource)
    dashboard_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end
end