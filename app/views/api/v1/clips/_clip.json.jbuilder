json.id clip.id
json.video_url clip.video_url
json.reel_id clip.reel.id
json.created_at clip.created_at.to_time.to_i
json.user do
  json.partial! clip.user, partial: 'api/v1/users/user', as: :user
end
