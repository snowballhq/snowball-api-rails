class Api::V1::ParticipationsController < ApiController
  before_action :authenticate!
  before_action :set_participation, only: [:update, :destroy]
  before_action :set_reel, only: [:index, :create]

  def index
    @participations = @reel.participations
  end

  def create
    @participation = Participation.new(participation_params)

    respond_to do |format|
      if @participation.save
        format.html { redirect_to @participation, notice: 'Participation was successfully created.' }
        format.json { render :show, status: :created, location: @participation }
      else
        format.html { render :new }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @participation.update(participation_params)
        format.html { redirect_to @participation, notice: 'Participation was successfully updated.' }
        format.json { render :show, status: :ok, location: @participation }
      else
        format.html { render :edit }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
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
