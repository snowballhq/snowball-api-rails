class Api::V1::ClipsController < Api::V1::ApiController
  before_action :set_clip, only: [:show, :edit, :update, :destroy]

  def index
    @clips = Clip.all
  end

  def show
  end

  def create
    @clip = Clip.new clip_params
    if @clip.save
      render :show, status: :created, location: api_v1_clip_url(@clip)
    else
      render json: @clip.errors, status: :unprocessable_entity
    end
  end

  def update
    if @clip.update(clip_params)
      render :show, status: :ok, location: api_v1_clip_url(@clip)
    else
      render json: @clip.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @clip.destroy
    head :no_content
  end

  private

  def set_clip
    @clip = Clip.find params[:id]
  end

  def clip_params
    params.require(:clip).permit(:video)
  end
end
