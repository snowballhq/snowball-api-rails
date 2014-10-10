class Api::V1::UsersController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_user, only: [:show, :update, :phone_number_change, :phone_number_verification]

  def show
  end

  def update
    @user.update!(user_params)
    render :show, status: :ok, location: api_v1_user_url(@user)
  end

  def find_by_contacts
    contacts = params[:contacts]
    phone_numbers = contacts.map do |contact|
      PhonyRails.normalize_number(contact[:phone_number], default_country_code: 'US')
    end
    @users = User.where.not(phone_number: nil, phone_number_verified: false).where(phone_number: phone_numbers)
    render :index, status: :ok, location: api_v1_user_url(@users)
  end

  def phone_number_change
    phone_params = params.require(:user).permit(:phone_number)
    phone_params[:phone_number_verification_code] = "#{Array.new(4){rand 10}.join}"
    phone_params[:phone_number_verified] = false
    @user.update! phone_params
    unless Rails.env.test?
      twilio = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
      twilio.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: @user.phone_number,
      body: "Your Snowball code is #{@user.phone_number_verification_code}. Enjoy!"
      )
    end
    render :show, status: :ok, location: api_v1_user_url(@user)
  end

  def phone_number_verification
    phone_params = params.require(:user).permit(:phone_number_verification_code)
    phone_number_verification_code = phone_params[:phone_number_verification_code]
    fail Snowball::InvalidPhoneNumberVerificationCode unless phone_number_verification_code == @user.phone_number_verification_code
    @user.phone_number_verification_code = nil
    @user.phone_number_verified = true
    @user.save!
    render :show, status: :ok, location: api_v1_user_url(@user)
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :username, :password, :email)
  end
end
