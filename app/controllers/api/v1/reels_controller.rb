class Api::V1::ReelsController < ApiController
  before_action :authenticate!
  before_action :set_reel, only: :update
  before_action :set_user, only: :index

  def index
    @reels = @user.reels
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

  def set_user
    @user = @current_user
  end

  def reel_params
    params.permit(
      :title
    )
  end
end
