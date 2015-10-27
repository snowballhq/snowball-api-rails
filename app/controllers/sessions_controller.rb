class SessionsController < ApplicationController
  def create
    fail Snowball::EmailRequired unless user_params[:email].present?
    fail Snowball::PasswordRequired unless user_params[:password].present?
    existing_user = User.where(email: user_params[:email]).first
    fail Snowball::UserDoesNotExist if existing_user.nil?
    fail Snowball::PasswordDoesNotMatch unless existing_user.authenticate(user_params[:password])
    @current_user = @user = existing_user
  end

  private

  def user_params
    params.permit(
      :email,
      :password
    )
  end
end
