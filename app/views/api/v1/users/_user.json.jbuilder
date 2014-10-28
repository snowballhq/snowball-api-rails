json.cache! user do
  json.id user.id
  json.username user.username
  json.avatar_url nil
  json.auth_token user.auth_token if action_name == 'phone_verification'
end
