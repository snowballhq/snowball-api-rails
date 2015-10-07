def authenticated_env
  {
    'AUTHORIZATION': 'Basic ' + Base64.encode64(User.first.auth_token + ':')
  }
end
