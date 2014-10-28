class Api::V1::ClipsController < ApiController
  before_action :authenticate!

  def index
    # TODO: pagination
    # TODO: scope to user following
    @clips = Clip.all
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
