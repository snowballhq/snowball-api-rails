class Api::V1::UsersController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_user, only: [:show]

  def show
  end

  private

  def set_user
    @user = User.find params[:id]
  end
end
