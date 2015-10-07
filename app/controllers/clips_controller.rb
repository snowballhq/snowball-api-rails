class ClipsController < ApiController
  before_action :set_clip, only: :destroy

  def index
    if params[:user_id]
      user_ids = [params[:user_id]]
    else
      user_ids = current_user.follows.pluck(:following_id).append(current_user.id)
    end
    @clips = Clip.includes(:user).where(user_id: user_ids).last(25)
  end

  def create
    @clip = current_user.clips.create!(clip_params)
    render status: :created
  end

  def destroy
    if @clip.user == current_user
      @clip.destroy!
      head :no_content
    else
      head :forbidden
    end
  end

  private

  def set_clip
    @clip = Clip.find(params[:id])
  end

  def clip_params
    params.permit(
      :video,
      :thumbnail
    )
  end
end
