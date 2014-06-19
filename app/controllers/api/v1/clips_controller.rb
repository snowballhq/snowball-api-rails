class Api::V1::ClipsController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_clip, only: [:edit, :update, :destroy]
  before_action :set_reel, only: :index

  def index
    @clips = @reel.clips.where('zencoder_job_id IS NULL').page(page_params)
  end

  def create
    @clip = current_user.clips.create! clip_params
    # TODO: make this cleaner, done in the model
    # Through the model will allow creation via rails c, etc.
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
    params[:clip][:reel_attributes] = nil unless params[:clip][:reel_attributes][:name].present?
    params.require(:clip).permit(:video, :reel_id, reel_attributes: [:name])
  end
end
