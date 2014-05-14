class Api::V1::ClipsController < Api::V1::ApiController
  before_action :set_clip, only: [:show, :edit, :update, :destroy]

  def index
    @clips = Clip.where('zencoder_job_id IS NULL').page(page_params)
  end

  def show
  end

  def create
    @clip = Clip.create! clip_params
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

  def clip_params
    params[:clip] = {} unless params[:clip].present?
    params[:clip][:video] = params[:video] if params[:video].present?
    params.delete :video
    params.require(:clip).permit(:video, :reel_id)
  end
end
