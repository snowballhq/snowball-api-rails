class Api::V1::UsersController < ApiController
  before_action :authenticate!, except: [:create]
  before_action :set_user, only: [:show, :update]

  def index
    @users = User.all
    @users = @users.where(phone_number: params[:phone_number].split(',')) if params[:phone_number].present?
  end

  def show
  end

  def update
    @user.update!(user_params)
    head :no_content
  end

  def phone_auth
    @user = User.where(user_params).first_or_initialize
    return unless @user.new_record?
    @user.save!
    render status: :created
  end

  private

  def set_user
    if params[:id] = 'me'
      @user = @current_user
      return
    end
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(
      :name,
      :phone_number
    )
  end
end
