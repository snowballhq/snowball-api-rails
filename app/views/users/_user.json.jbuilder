is_authenticating = (controller_name == 'registrations' || controller_name == 'sessions')
is_authenticated = @current_user.present?
is_current_user = (is_authenticated && user == @current_user)
is_getting_me = (is_current_user && controller_name == 'users' && action_name == 'show')

json.id user.id
json.username user.username
json.email user.email if is_getting_me
if user.avatar.present?
  json.avatar_url user.avatar.url
else
  json.avatar_url nil
end
json.follower user.following?(@current_user) unless is_current_user || !is_authenticated
json.following @current_user.following?(user) unless is_current_user || !is_authenticated
json.phone_number user.phone_number if is_getting_me
json.auth_token user.auth_token if is_authenticating
