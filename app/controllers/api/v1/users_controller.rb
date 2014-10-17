class Api::V1::UsersController < ApiController
  before_action :authenticate!, except: [:create]
  before_action :set_user, only: [:show, :update]

  def index
    @users = User.all
    @users = @users.where(phone_number: params[:phone_number].split(',')) if params[:phone_number].present?
  end

  def show
  end

  def create
    @user = User.where(user_params).first_or_initialize
    return unless @user.new_record?
    @user.save!
    render status: :created
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = @current_user
  end

  def user_params
    params.permit(
      :phone_number
    )
  end
end
