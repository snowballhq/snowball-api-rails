json.id user.id
json.username user.username
json.name user.name
json.bio user.bio
json.avatar_url user.avatar_url
# This nested if/else is because of a problem signing up with the current_user
# method. If that changes, this can be updated to a much cleaner solution.
if controller_name == 'sessions' || controller_name == 'registrations'
  json.email user.email
  json.auth_token user.auth_token
elsif user == current_user
  json.email user.email
else
  json.following current_user.following?(user)
end
