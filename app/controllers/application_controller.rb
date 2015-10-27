class ApplicationController < ActionController::API
  before_action :optionally_authenticate_user
  before_action :authenticate_user!, unless: -> { controller_name == 'registrations' || controller_name == 'sessions' }

  class Snowball::UsernameRequired < StandardError
  end
  class Snowball::EmailRequired < StandardError
  end
  class Snowball::PasswordRequired < StandardError
  end
  class Snowball::UsernameInUse < StandardError
  end
  class Snowball::UserDoesNotExist < StandardError
  end
  class Snowball::PasswordDoesNotMatch < StandardError
  end
  class Snowball::Unauthorized < StandardError
  end

  rescue_from ActiveRecord::RecordInvalid, with: :render_error
  rescue_from ActionController::ParameterMissing, with: :render_error
  rescue_from Snowball::UsernameRequired, with: :render_error
  rescue_from Snowball::EmailRequired, with: :render_error
  rescue_from Snowball::PasswordRequired, with: :render_error
  rescue_from Snowball::UsernameInUse, with: :render_error
  rescue_from Snowball::UserDoesNotExist, with: :render_error
  rescue_from Snowball::PasswordDoesNotMatch, with: :render_error
  rescue_from Snowball::Unauthorized, with: :render_error

  def render_error(error)
    status = :bad_request
    if error.is_a? ActiveRecord::RecordInvalid
      message = error.record.errors.full_messages.first
    elsif error.is_a? ActionController::ParameterMissing
      message = error.message
    elsif error.is_a? Snowball::UsernameRequired
      message = 'Your username must have at least 3 characters. Try again.'
    elsif error.is_a? Snowball::EmailRequired
      message = 'That doesn\'t look like an email address. Try again.'
    elsif error.is_a? Snowball::PasswordRequired
      message = 'Your password must have at least 5 characters. Try again.'
    elsif error.is_a? Snowball::UsernameInUse
      message = 'That username is already taken. Try another one.'
    elsif error.is_a? Snowball::UserDoesNotExist
      message = 'A user with that email address does not exist. Try another one or sign up.'
    elsif error.is_a? Snowball::PasswordDoesNotMatch
      message = 'That password doesn\'t match. Try again.'
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
