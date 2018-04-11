class TermsController < ApplicationController
  skip_before_action :authenticate_admin!, only: %i[show]
  def show; end
end