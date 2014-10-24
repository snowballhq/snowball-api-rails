class Api::V1::ParticipationsController < ApiController
  before_action :authenticate!
  before_action :set_participation, only: [:update, :destroy]
  before_action :set_reel, only: :index

  def index
    @participations = @reel.participations
  end

  def create
    @participation = Participation.create!(participation_params)
    render status: :created
  end

  def update
    @participation.update!(participation_params)
    head :no_content
  end

  def destroy
    @participation.destroy
    respond_to do |format|
      format.html { redirect_to participations_url, notice: 'Participation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_participation
    @participation = Participation.find(params[:id])
  end

  def set_reel
    @reel = Reel.find(params[:reel_id])
  end

  def participation_params
    params.permit(
      :reel_id,
      :user_id,
      :last_watched_clip_id
    )
  end
end
