class Api::V1::ClipsController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_clip, only: [:edit, :update, :destroy]
  before_action :set_reel, only: [:index, :create]

  def index
    @clips = @reel.encoded_clips
    if params[:max_date].present?
      # @clips = @clips.where("created_at <= ?", Time.at(params[:max_date].to_i))
    elsif params[:since_date].present?
      @clips = @clips.where('created_at >= ?', Time.at(params[:since_date].to_i))
    end
    @clips = @clips.last(10)
  end

  def create
    user_clip_params = clip_params.merge(user_id: current_user.id)
    @clip = @reel.clips.create!(user_clip_params)
  end

  private

  def set_clip
    @clip = Clip.find params[:id]
  end

  def set_reel
    @reel = Reel.find params[:reel_id]
  end

  def clip_params
    params.require(:clip).permit(:video, reel_attributes: [:name, participant_ids: []])
  end
end
