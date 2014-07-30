class Api::V1::ClipsController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_clip, only: [:edit, :update, :destroy]
  before_action :set_reel, only: :index

  def index
    @clips = @reel.clips
    if params[:max_date].present?
      # @clips = @clips.where("created_at <= ?", Time.at(params[:max_date].to_i))
    elsif params[:since_date].present?
      @clips = @clips.where('created_at >= ?', Time.at(params[:since_date].to_i))
    end
    @clips = @clips.last(10)
  end

  def create
    # TODO: clean up this ugly black magic. :)
    # Create a new reel manually unless it's being assigned to an existing reel
    # or is creating one using nested attributes
    if clip_params[:reel_id].present? || clip_params[:reel_attributes].present?
      @clip = current_user.clips.create! clip_params
    else
      reel = Reel.create! clip_params[:reel_attributes]
      @clip = reel.clips.create! clip_params.merge(user_id: current_user.id)
    end
    if @clip.reel.participants.count == 0
      @clip.reel.participants << current_user
      @clip.reel.save!
    end
    render :show, status: :created, location: api_v1_clip_url(@clip)
  end

  def update
    @clip.update! clip_params
    render :show, status: :ok, location: api_v1_clip_url(@clip)
  end

  def destroy
    @clip.destroy!
    head :no_content
  end

  private

  def set_clip
    @clip = Clip.find params[:id]
  end

  def set_reel
    @reel = Reel.find params[:reel_id]
  end

  def clip_params
    params[:clip] = {} unless params[:clip].present?
    params[:clip][:reel_id] = params[:reel_id] if params[:reel_id].present?
    params.require(:clip).permit(:video, :reel_id, reel_attributes: [:name])
  end
end
