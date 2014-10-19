class Api::V1::ReelsController < ApiController
  before_action :set_reel, only: :update

  def index
    @reels = Reel.all
  end

  def create
    @reel = Reel.create!(reel_params)
    render status: :created
  end

  def update
    @reel.update!(reel_params)
    head :no_content
  end

  private

  def set_reel
    @reel = Reel.find(params[:id])
  end

  def reel_params
    params.permit(
      :title
    )
  end
end
