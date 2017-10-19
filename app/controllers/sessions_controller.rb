class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    super
  end

  def create
    super
  end
end