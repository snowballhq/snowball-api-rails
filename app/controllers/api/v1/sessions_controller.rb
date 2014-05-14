class Api::V1::SessionsController < Api::V1::ApiController
  include Devise::Controllers::Helpers

  def create
    # if params[:provider] == 'facebook'
    #   profile = User.get_facebook_profile params[:access_token]
    #   uid = profile[:id]
    #   remote_image_url = "http://graph.facebook.com/#{uid}/picture?width=100&height=100"
    #   auth_hash = { provider: params[:provider], uid: uid, name: profile[:name], email: profile[:email], remote_image_url: remote_image_url }
    #   @user = User.find_or_create_by_auth_hash auth_hash
    # else
    user = User.find_for_database_authentication(email: user_params[:email])
    fail Snowball::InvalidCredentials, 'Email address not found.' if user.nil?
    if user.valid_password? user_params[:password]
      # should we be calling this next method here? it fails though.
      # sign_in(:user, user)
      @user = user
    else
      fail Snowball::InvalidCredentials, 'Invalid password.'
    end
    # end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
