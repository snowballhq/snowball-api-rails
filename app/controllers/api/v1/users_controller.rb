class Api::V1::UsersController < ApiController
  before_action :authenticate!, except: [:phone_auth, :phone_verification, :sign_in, :sign_up]
  before_action :set_user, only: [:show, :update, :phone_verification]

  def index
    @users = User.where(username: params[:username]) if params[:username].present?
  end

  def show
  end

  def update
    @user.update!(user_params)
    head :no_content
  end

  def phone_search
    phone_numbers = params[:phone_numbers].map do |phone_number|
      PhonyRails.normalize_number(phone_number, default_country_code: 'US')
    end
    @users = User.where(phone_number: phone_numbers)
  end

  def phone_auth
    phone_number = PhonyRails.normalize_number(user_params[:phone_number])
    @user = User.where(phone_number: phone_number).first_or_initialize
    user_is_new = @user.new_record?
    @user.username = SecureRandom.urlsafe_base64(5) if user_is_new
    @user.password = SecureRandom.urlsafe_base64(10) if user_is_new
    @user.email = "autogen#{SecureRandom.urlsafe_base64(10)}@snowball.is"
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

  def sign_in
    fail Snowball::InvalidEmail unless user_params[:email].present?
    fail Snowball::InvalidPassword unless user_params[:password].present?
    @user = User.where(email: user_params[:email]).first
    fail Snowball::InvalidEmail if @user.nil?
    @user.authenticate(user_params[:password])
    fail Snowball::InvalidPassword if @user.nil?
  end

  def sign_up
    fail Snowball::InvalidUsername unless user_params[:username].present?
    fail Snowball::InvalidPassword unless user_params[:password].present?
    @user = User.where(username: user_params[:username]).first
    fail Snowball::UsernameInUse if @user.present?
    @user = User.create!(user_params)
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
      :email,
      :password,
      :phone_number
    )
  end
end
