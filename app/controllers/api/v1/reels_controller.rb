class Api::V1::ReelsController < Api::V1::ApiController
  before_action :set_reel, only: [:show, :edit, :update, :destroy]

  def index
    @reels = Reel.all.page(page_params)
  end

  def show
  end

  def create
    @reel = Reel.create! reel_params
    render :show, status: :created, location: api_v1_reel_url(@reel)
  end

  def update
    @reel.update! reel_params
    render :show, status: :ok, location: api_v1_reel_url(@reel)
  end

  def destroy
    @reel.destroy!
    head :no_content
  end

  private

  def set_reel
    @reel = Reel.find params[:id]
  end

  def reel_params
    params.require(:reel).permit(:name)
  end
end
