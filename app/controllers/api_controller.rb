class ApiController < ApplicationController
  protect_from_forgery with: :null_session

  class Snowball::InvalidPhoneNumberVerificationCode < StandardError
  end

  rescue_from StandardError, with: :render_error

  def render_error(error)
    if error.is_a? ActiveRecord::RecordInvalid
      message = error.record.errors.full_messages.first
      status = :bad_request
    elsif error.is_a? ActionController::ParameterMissing
      message = error.message
      status = :bad_request
    elsif error.is_a? Snowball::InvalidPhoneNumberVerificationCode
      message = 'Looks like you typed in incorrect numbers. Please try again.'
      status = :bad_request
    else
      logger.error error.message
      message = 'An unexpected error has occured.'
      status = :internal_server_error
    end
    render json: { message: message }, status: status
  end

  protected

  def authenticate!
    if Rails.env.test?
      @current_user = User.last
      return
    end
    authenticate_or_request_with_http_basic do |auth_token|
      @current_user = User.where(auth_token: auth_token).first
      if @current_user.present?
        true
      else
        false
      end
    end
  end
end
