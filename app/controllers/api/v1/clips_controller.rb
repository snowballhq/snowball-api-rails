class Api::V1::ClipsController < ApiController
  def index
    user_ids = current_user.follows.pluck(:following_id).append(current_user.id)
    @clips = Clip.includes(:user).where(user_id: user_ids).last(25)
  end

  def create
    @clip = current_user.clips.create!(clip_params)
    render status: :created
  end

  private

  def clip_params
    params.permit(
      :video,
      :thumbnail
    )
  end
end
