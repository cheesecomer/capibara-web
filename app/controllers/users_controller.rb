class UsersController < ApplicationController
  layout 'admin'
  before_action only: [:show, :edit, :update, :destroy] do
    @user = User.find(params[:id])
  end

  def index
    @users = User.includes(:reports).order((params[:order_by] || :created_at) => (params[:order] || :asc))
  end

  def show; end

  def destroy
    @user.destroy
    head :no_content
  end
end
