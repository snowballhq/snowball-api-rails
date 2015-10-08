class ApplicationController < ActionController::API
  before_action :optionally_authenticate_user
  before_action :authenticate_user!, unless: -> { controller_name == 'registrations' || controller_name == 'sessions' }

  class Snowball::InvalidUsername < StandardError
  end
  class Snowball::InvalidEmail < StandardError
  end
  class Snowball::InvalidPassword < StandardError
  end
  class Snowball::UsernameInUse < StandardError
  end
  class Snowball::Unauthorized < StandardError
  end

  rescue_from ActiveRecord::RecordInvalid, with: :render_error
  rescue_from ActionController::ParameterMissing, with: :render_error
  rescue_from Snowball::InvalidUsername, with: :render_error
  rescue_from Snowball::InvalidEmail, with: :render_error
  rescue_from Snowball::InvalidPassword, with: :render_error
  rescue_from Snowball::UsernameInUse, with: :render_error
  rescue_from Snowball::Unauthorized, with: :render_error

  def render_error(error)
    status = :bad_request
    if error.is_a? ActiveRecord::RecordInvalid
      message = error.record.errors.full_messages.first
    elsif error.is_a? ActionController::ParameterMissing
      message = error.message
    elsif error.is_a? Snowball::InvalidUsername
      message = 'Invalid username. Please try again.'
    elsif error.is_a? Snowball::InvalidEmail
      message = 'Invalid email. Please try again.'
    elsif error.is_a? Snowball::InvalidPassword
      message = 'Invalid password. Please try again.'
    elsif error.is_a? Snowball::UsernameInUse
      message = 'Username is already in use. Please select another or try to sign in.'
    elsif error.is_a? Snowball::Unauthorized
      status = :unauthorized
      message = 'Unauthorized'
    else
      logger.error error.message
      message = 'An unexpected error has occured.'
      status = :internal_server_error
    end
    render json: { message: message }, status: status
  end

  protected

  def current_user
    return @current_user if @current_user
    basic = ActionController::HttpAuthentication::Basic
    return nil unless basic.has_basic_credentials?(request)
    auth_token, = basic.user_name_and_password(request)
    user = User.where(auth_token: auth_token).first
    return nil unless user
    @current_user = user
    @current_user
  end

  def optionally_authenticate_user
    current_user
  end

  def authenticate_user!
    fail Snowball::Unauthorized unless current_user
  end
end
