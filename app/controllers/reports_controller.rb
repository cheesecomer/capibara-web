class ReportsController < ApplicationController
  layout 'admin'

  def index
    @reports = Report.includes(:sender, :target).joins(:sender, :target).order :created_at
  end
end
