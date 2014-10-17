class ApiController < ApplicationController
  protect_from_forgery with: :null_session

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
