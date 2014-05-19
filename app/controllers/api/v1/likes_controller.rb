class Api::V1::LikesController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_clip, only: [:create, :destroy]

  def create
    like = Like.where(user: current_user, likeable: @clip)
    current_user.liked.create!(likeable: @clip) unless like.present?
    head :created
  end

  def destroy
    @clip.likes.where(user: current_user).first.destroy
    head :no_content
  end

  private

  def set_clip
    @clip = Clip.find(params[:clip_id])
  end
end
