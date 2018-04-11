module Rescue
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :rescue422
    rescue_from ActiveModel::ValidationError, with: :rescue422
  end

  def rescue422(e)
    request.format = :json if request.xhr?

    errors = []
    errors = e.record.errors if e.is_a?(ActiveRecord::RecordInvalid)
    errors = e.model.errors  if e.is_a?(ActiveModel::ValidationError)

    respond_to do |format|
      format.json { render_unprocessable_entity(errors) }
    end
  end

  private

  def render_unprocessable_entity(errors)
    render \
      '/api/errors/unprocessable_entity',
      locals: { errors: errors },
      status: :unprocessable_entity
  end

end