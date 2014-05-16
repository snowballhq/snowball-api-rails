class Api::V1::RegistrationsController < Api::V1::ApiController
  def create
    @user = User.create! user_params
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :username)
  end
end