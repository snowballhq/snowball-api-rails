json.users do
  json.partial! collection: @users, partial: 'api/v1/users/user', as: :user
end
