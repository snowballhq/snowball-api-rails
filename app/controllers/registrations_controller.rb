class RegistrationsController < ApplicationController
  def create
    fail Snowball::InvalidUsername unless user_params[:username].present?
    fail Snowball::InvalidPassword unless user_params[:password].present?
    existing_user = User.where(username: user_params[:username]).first
    fail Snowball::UsernameInUse if existing_user.present?
    @current_user = @user = User.create!(user_params)
  end

  private

  def user_params
    params.permit(
      :username,
      :email,
      :password
    )
  end
end
