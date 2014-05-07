class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session

  rescue_from StandardError, with: :render_error
  rescue_from ActiveRecord::RecordInvalid, with: :render_error
  rescue_from ActionController::ParameterMissing, with: :render_error

  protected

  # TODO: spec this using a shared spec
  def render_error(error)
    if error.kind_of? ActiveRecord::RecordInvalid
      message = error.record.errors.full_messages.first
      status = :unprocessable_entity
    elsif error.kind_of? ActionController::ParameterMissing
      message = error.message
      status = :unprocessable_entity
    else
      logger.error error.message
      message = 'An unexpected error has occured.'
      status = :internal_server_error
    end
    render json: { message: message }, status: status
  end
end
