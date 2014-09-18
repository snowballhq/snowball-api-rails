class Api::V1::UsersController < Api::V1::ApiController
  before_action :restrict_access!
  before_action :set_user, only: [:show, :update]

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
    @users = User.where.not(phone_number: nil).where(phone_number: phone_numbers)
    render :index, status: :ok, location: api_v1_user_url(@users)
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :username, :password, :email, :phone_number)
  end
end
