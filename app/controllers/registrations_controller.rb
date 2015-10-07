class RegistrationsController < ApplicationController
  def create
    fail Snowball::InvalidUsername unless user_params[:username].present?
    fail Snowball::InvalidPassword unless user_params[:password].present?
    @user = User.where(username: user_params[:username]).first
    fail Snowball::UsernameInUse if @user.present?
    @user = User.create!(user_params)
    sign_in @user, store: false
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
