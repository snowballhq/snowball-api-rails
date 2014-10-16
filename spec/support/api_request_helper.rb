module ApiRequestHelper
  def auth(auth_token)
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(auth_token, '')
  end
end
