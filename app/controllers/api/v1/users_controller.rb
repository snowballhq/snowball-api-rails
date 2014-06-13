class Api::V1::UsersController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_user

  def show
  end

  def update
    @user.update!(user_params)
    render :show, status: :ok, location: api_v1_user_url(@user)
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:name, :username, :password, :email, :bio, :phone_number)
  end
end
