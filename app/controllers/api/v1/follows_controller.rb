class Api::V1::FollowsController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_user, only: [:create, :destroy]

  def following
    @users = current_user.friends
  end

  def create
    follow = Follow.where(user: current_user, followable: @user)
    current_user.follows.create!(followable: @user) unless follow.present?
  end

  def destroy
    current_user.follows.where(followable: @user).first.destroy!
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
