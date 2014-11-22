class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  class Snowball::InvalidPhoneNumberVerificationCode < StandardError
  end
  class Snowball::InvalidUsername < StandardError
  end
  class Snowball::InvalidPassword < StandardError
  end
  class Snowball::UsernameInUse < StandardError
  end

  rescue_from ActiveRecord::RecordInvalid, with: :render_error
  rescue_from ActionController::ParameterMissing, with: :render_error
  rescue_from Snowball::InvalidPhoneNumberVerificationCode, with: :render_error
  rescue_from Snowball::InvalidUsername, with: :render_error
  rescue_from Snowball::InvalidPassword, with: :render_error
  rescue_from Snowball::UsernameInUse, with: :render_error

  def render_error(error)
    status = :bad_request
    if error.is_a? ActiveRecord::RecordInvalid
      message = error.record.errors.full_messages.first
    elsif error.is_a? ActionController::ParameterMissing
      message = error.message
    elsif error.is_a? Snowball::InvalidPhoneNumberVerificationCode
      message = 'Looks like you typed in incorrect numbers. Please try again.'
    elsif error.is_a? Snowball::InvalidUsername
      message = 'Invalid username. Please try again.'
    elsif error.is_a? Snowball::InvalidPassword
      message = 'Invalid password. Please try again.'
    elsif error.is_a? Snowball::UsernameInUse
      message = 'Username is already in use. Please select another or try to sign in.'
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
