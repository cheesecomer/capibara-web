class Api::ReportsController < Api::ApplicationController
  def create
    Report.create! create_params.merge(sender: current_user)
    head :no_content
  end

  def create_params
    params.require(:report).permit(:target_id, :reason, :message)
  end
end