class ReelsController < ApplicationController
  before_action :set_reel, only: [:show, :edit, :update, :destroy]

  def index
    @reels = Reel.all
  end

  def show
  end

  def new
    @reel = Reel.new
  end

  def edit
  end

  def create
    @reel = Reel.new(reel_params)

    respond_to do |format|
      if @reel.save
        format.html { redirect_to @reel, notice: 'Reel was successfully created.' }
        format.json { render :show, status: :created, location: @reel }
      else
        format.html { render :new }
        format.json { render json: @reel.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @reel.update(reel_params)
        format.html { redirect_to @reel, notice: 'Reel was successfully updated.' }
        format.json { render :show, status: :ok, location: @reel }
      else
        format.html { render :edit }
        format.json { render json: @reel.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reel.destroy
    respond_to do |format|
      format.html { redirect_to reels_url, notice: 'Reel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_reel
    @reel = Reel.find(params[:id])
  end

  def reel_params
    params[:reel]
  end
end
