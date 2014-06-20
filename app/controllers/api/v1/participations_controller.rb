class Api::V1::ParticipationsController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_reel
  before_action :set_participant, only: [:create, :destroy]

  def index
    @participants = @reel.participants.page(page_params)
  end

  def create
    @reel.participants << @participant
    head :created
  end

  def destroy
    @reel.participants.delete(@participant)
    head :no_content
  end

  private

  def set_reel
    @reel = Reel.find(params[:reel_id])
  end

  def set_participant
    if params[:user_id]
      @participant = User.find(params[:user_id])
    else
      @participant = User.find(params[:user][:id])
    end
  end
end
