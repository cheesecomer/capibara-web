class ReportsController < ApplicationController
  layout 'admin'

  def index
    @reports = Report.includes(:sender, :target).order :created_at
  end
end
