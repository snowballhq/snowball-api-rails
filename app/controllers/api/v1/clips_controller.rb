class Api::V1::ClipsController < ApiController
  before_action :authenticate!

  def index
    # TODO: pagination
    user_ids = @current_user.follows.pluck(:following_id)
    @clips = Clip.where(user_id: user_ids)
  end

  def create
    @clip = @current_user.clips.create!(clip_params)
    render status: :created
  end

  private

  def clip_params
    params.permit(
      :video
    )
  end
end
