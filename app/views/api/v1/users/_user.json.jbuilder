json.id user.id
json.username user.username
json.email user.email if @current_user.present? && user == @current_user
json.avatar_url nil
json.you_follow @current_user.following?(user) unless @current_user.nil? || user == @current_user
json.phone_number user.phone_number if controller_name == 'users' && action_name == 'show' && user == @current_user
json.auth_token user.auth_token if action_name == 'phone_verification' || action_name == 'sign_in' || action_name == 'sign_up'
