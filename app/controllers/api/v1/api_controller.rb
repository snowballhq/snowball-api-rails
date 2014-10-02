class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session

  class Snowball::InvalidCredentials < StandardError
  end

  # rescue_from StandardError, with: :render_error
  rescue_from Snowball::InvalidCredentials, with: :render_error
  rescue_from ActiveRecord::RecordInvalid, with: :render_error
  rescue_from ActionController::ParameterMissing, with: :render_error

  protected

  # TODO: spec entire APIController using a shared spec

  def restrict_access!
    authenticate_or_request_with_http_basic do |_username, _password|
      user = current_user
      if user.present?
        @current_user = user
        true
      else
        false
      end
    end
  end

  def current_user
    credentials = ActionController::HttpAuthentication::Basic.user_name_and_password request
    username = credentials.first
    User.where(auth_token: username).first
  end

  def render_error(error)
    if error.is_a? ActiveRecord::RecordInvalid
      message = error.record.errors.full_messages.first
      status = :unprocessable_entity
    elsif error.is_a? Snowball::InvalidCredentials
      message = error.message
      status = :bad_request
    elsif error.is_a? ActionController::ParameterMissing
      message = error.message
      status = :unprocessable_entity
    else
      logger.error error.message
      message = 'An unexpected error has occured.'
      status = :internal_server_error
    end
    render json: { error: { message: message } }, status: status
  end

  def page_params
    params.permit(:page)[:page]
  end
end
