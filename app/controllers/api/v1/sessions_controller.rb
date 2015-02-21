class Api::V1::SessionsController < ApiController
  def create
    fail Snowball::InvalidEmail unless user_params[:email].present?
    fail Snowball::InvalidPassword unless user_params[:password].present?
    @user = User.where(email: user_params[:email]).first
    fail Snowball::InvalidEmail if @user.nil?
    fail Snowball::InvalidPassword unless @user.valid_password?(user_params[:password])
    sign_in @user, store: false
  end

  private

  def user_params
    params.permit(
      :email,
      :password
    )
  end
end
