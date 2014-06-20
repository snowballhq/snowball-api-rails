json.participants do
  json.partial! collection: @participants, partial: 'api/v1/users/user', as: :user
end
