class InquiriesController < ApplicationController
  skip_before_action :authenticate_admin!, only: %i[new create]
  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new create_params
    if @inquiry.save
      render :create
    else
      render :new
    end
  end

  private
  def create_params
    params.require(:inquiry).permit(:name, :email, :content)
  end
end
