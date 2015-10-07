class UsersController < ApiController
  before_action :set_user, only: [:show, :update]

  def index
    @users = User.where('username ILIKE ?', params[:username]) if params[:username].present?
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
    phone_numbers.delete('')
    phone_numbers.delete(nil)
    phone_numbers.delete(current_user.phone_number)
    @users = User.where(phone_number: phone_numbers)
  end

  private

  def set_user
    user_id = params[:id] if params[:id].present?
    user_id = params[:user_id] if params[:user_id].present?
    if user_id == 'me'
      @user = current_user
      return
    end
    @user = User.find(user_id)
  end

  def user_params
    params.permit(
      :username,
      :email,
      :password,
      :phone_number,
      :avatar
    )
  end
end
