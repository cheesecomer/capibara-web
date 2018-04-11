class Api::InquiriesController < Api::ApplicationController
  def create
    Inquiry.create! create_params.merge(sender: current_user)
    head :no_content
  end

  private
  def create_params
    params.require(:inquiry).permit(:email, :content)
  end
end