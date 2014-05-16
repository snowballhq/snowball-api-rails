module AuthRequestHelper
  def login_api(token)
    user = token
    pw = ''
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, pw)
  end
end
