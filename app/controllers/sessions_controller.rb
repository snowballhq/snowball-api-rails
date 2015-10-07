class SessionsController < ApplicationController
  def create
    fail Snowball::InvalidEmail unless user_params[:email].present?
    fail Snowball::InvalidPassword unless user_params[:password].present?
    existing_user = User.where(email: user_params[:email]).first
    fail Snowball::InvalidEmail if existing_user.nil?
    fail Snowball::InvalidPassword unless existing_user.authenticate(user_params[:password])
    @user = existing_user
  end

  private

  def user_params
    params.permit(
      :email,
      :password
    )
  end
end
