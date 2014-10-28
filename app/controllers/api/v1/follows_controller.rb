class Api::V1::FollowsController < ApiController
  before_action :authenticate!
  before_action :set_following

  def create
    Follow.create!(following: @following, follower: @current_user)
    head :created
  end

  def destroy
    follow = Follow.where(following: @following, follower: @current_user).first
    follow.destroy!
    head :no_content
  end

  private

  def set_following
    @following = User.find(params[:user_id])
  end
end
