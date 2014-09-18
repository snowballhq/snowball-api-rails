json.user do
  json.partial! collection: @participant, partial: 'api/v1/users/user', as: :user
end
