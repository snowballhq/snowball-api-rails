json.cache! participation do
  json.id participation.id
  json.user do
    json.partial! 'api/v1/users/user', user: participation.user
  end
end
