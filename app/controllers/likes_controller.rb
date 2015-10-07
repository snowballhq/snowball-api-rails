class LikesController < ApiController
  before_action :set_clip

  def create
    @clip.likes.create!(user: current_user)
    head :created
  end

  def destroy
    @clip.likes.where(user: current_user).destroy_all
    head :no_content
  end

  private

  def set_clip
    @clip = Clip.find(params[:clip_id])
  end
end
