class Api::V1::ClipsController < ApiController
  before_action :authenticate!
  before_action :set_reel, only: :index

  def index
    # TODO: pagination
    @clips = @reel.clips
  end

  def create
    @clip = @current_user.clips.create!(clip_params)
    render status: :created
  end

  private

  def set_reel
    @reel = Reel.find(params[:reel_id])
  end

  def clip_params
    params.permit(
      :reel_id,
      :video
    )
  end
end
