class Api::V1::LikesController < ApiController
  before_action :set_clip

  def create
    @clip.likes.create!(user: current_user)
    head :created
  end

  private

  def set_clip
    @clip = Clip.find(params[:clip_id])
  end
end
