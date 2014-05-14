json.user do
  json.partial! @user, partial: 'api/v1/users/user', as: :user
end