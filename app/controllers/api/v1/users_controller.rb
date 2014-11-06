class Api::V1::UsersController < ApiController
  before_action :authenticate!, except: [:phone_auth, :phone_verification]
  before_action :set_user, only: [:show, :update, :phone_verification]

  def index
    @users = User.all
    if params[:phone_number].present?
      phone_numbers = params[:phone_number].split(',').map do |phone_number|
        PhonyRails.normalize_number(phone_number)
      end
      @users = @users.where(phone_number: phone_numbers)
    end
    @users = @users.where(username: params[:username]) if params[:username].present?
  end

  def show
  end

  def update
    @user.update!(user_params)
    head :no_content
  end

  def phone_auth
    phone_number = PhonyRails.normalize_number(user_params[:phone_number])
    @user = User.where(phone_number: phone_number).first_or_initialize
    user_is_new = @user.new_record?
    @user.generate_phone_number_verification_code
    @user.send_verification_text
    @user.save!
    render status: :created if user_is_new
  end

  def phone_verification
    fail Snowball::InvalidPhoneNumberVerificationCode if @user.phone_number_verification_code != params[:phone_number_verification_code]
    @user.generate_auth_token
    @user.phone_number_verification_code = nil
    @user.save!
  end

  private

  def set_user
    user_id = params[:id] if params[:id].present?
    user_id = params[:user_id] if params[:user_id].present?
    if user_id == 'me'
      @user = @current_user
      return
    end
    @user = User.find(user_id)
  end

  def user_params
    params.permit(
      :username,
      :phone_number
    )
  end
end
