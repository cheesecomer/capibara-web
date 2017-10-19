class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  def after_sign_in_path_for(_resource)
    rooms_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end
end
