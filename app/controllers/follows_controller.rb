class FollowsController < ApiController
  before_action :set_following, only: [:create, :destroy]
  before_action :set_user, only: [:followers, :following]

  def create
    current_user.follow(@following)
    head :created
  end

  def destroy
    current_user.unfollow(@following)
    head :no_content
  end

  def followers
    @users = Follow.where(following: @user).map(&:follower)
  end

  def following
    @users = @user.follows.map(&:following)
  end

  private

  def set_user
    if params[:user_id] == 'me'
      @user = current_user
      return
    end
    @user = User.find(params[:user_id])
  end

  def set_following
    @following = User.find(params[:user_id])
  end
end
