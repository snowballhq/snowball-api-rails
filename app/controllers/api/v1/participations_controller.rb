class Api::V1::ParticipationsController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_reel
  before_action :set_participant, only: :create

  def index
    @users = @reel.participants.page(page_params)
  end

  def create
    @reel.participants << @participant
  end

  def destroy
    @reel.participants.destroy(current_user)
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
