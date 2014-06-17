json.id reel.id
json.name reel.name
json.updated_at reel.updated_at.to_time.to_i
json.recent_participants reel.recent_participants do |participant|
  json.partial! participant, partial: 'api/v1/users/user', as: :user
end
