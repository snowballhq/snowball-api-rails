class Api::V1::ReelsController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_reel, only: [:show, :edit, :update, :destroy]

  def index
    @reels = current_user.reels.page(page_params)
  end

  def create
    participant_ids = [current_user.id]
    # union the two arrays
    participant_ids |= reel_params[:participant_ids] unless reel_params[:participant_ids].nil?
    @reel = Reel.create! reel_params.merge!(participant_ids: participant_ids)
    render :show, status: :created, location: api_v1_reel_url(@reel)
  end

  def show
  end

  def update
    @reel.update! reel_params.except(:participant_ids)
    render :show, status: :ok, location: api_v1_reel_url(@reel)
  end

  private

  def set_reel
    @reel = Reel.find params[:id]
  end

  def reel_params
    params.require(:reel).permit(:name, participant_ids: [])
  end
end
