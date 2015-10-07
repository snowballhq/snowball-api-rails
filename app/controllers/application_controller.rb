class ApplicationController < ActionController::Base
  before_action do
    request.format = :json
  end

  # before_action :authenticate_user_from_token!, unless: -> { controller_name == 'registrations' || controller_name == 'sessions' }
  before_action :authenticate_user!, unless: -> { controller_name == 'registrations' || controller_name == 'sessions' }

  class Snowball::InvalidUsername < StandardError
  end
  class Snowball::InvalidEmail < StandardError
  end
  class Snowball::InvalidPassword < StandardError
  end
  class Snowball::UsernameInUse < StandardError
  end

  rescue_from ActiveRecord::RecordInvalid, with: :render_error
  rescue_from ActionController::ParameterMissing, with: :render_error
  rescue_from Snowball::InvalidUsername, with: :render_error
  rescue_from Snowball::InvalidEmail, with: :render_error
  rescue_from Snowball::InvalidPassword, with: :render_error
  rescue_from Snowball::UsernameInUse, with: :render_error

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
    else
      logger.error error.message
      message = 'An unexpected error has occured.'
      status = :internal_server_error
    end
    render json: { message: message }, status: status
  end

  protected

  def authenticate_user!
    if Rails.env.test?
      @current_user = User.first
      return
    end
    auth_token, = ActionController::HttpAuthentication::Basic.user_name_and_password(request)
    @current_user = User.where(auth_token: auth_token).first
  end
end
