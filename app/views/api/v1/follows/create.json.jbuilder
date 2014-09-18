json.user do
  json.partial! collection: @user, partial: 'api/v1/users/user', as: :user
end
