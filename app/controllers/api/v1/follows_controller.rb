class Api::V1::FollowsController < ApiController
  before_action :authenticate!
  before_action :set_following, except: :following
  before_action :set_user, only: :following

  def create
    Follow.create!(following: @following, follower: @current_user)
    head :created
  end

  def destroy
    follow = Follow.where(following: @following, follower: @current_user).first
    follow.destroy!
    head :no_content
  end

  def following
    @users = @user.follows.map(&:following)
  end

  private

  def set_user
    if params[:user_id] == 'me'
      @user = @current_user
      return
    end
    @user = User.find(params[:user_id])
  end

  def set_following
    @following = User.find(params[:user_id])
  end
end
