class Api::V1::SessionsController < Api::V1::ApiController
  include Devise::Controllers::Helpers

  def create
    if params[:provider] == 'facebook'
      facebook_profile = User.get_facebook_profile params[:access_token]
      uid = facebook_profile[:id]
      photo_url = "https://graph.facebook.com/#{uid}/picture?width=100&height=100"
      auth_hash = { provider: params[:provider], uid: uid, name: facebook_profile[:name], email: facebook_profile[:email], avatar: open(photo_url) }
      @user = User.find_or_create_by_auth_hash auth_hash
    else
      user = User.find_for_database_authentication(email: user_params[:email])
      fail Snowball::InvalidCredentials, 'Email address not found.' if user.nil?
      if user.valid_password? user_params[:password]
        @user = user
      else
        fail Snowball::InvalidCredentials, 'Invalid password.'
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
