json.id clip.id
json.video_url clip.encoded_video_url
json.reel do
  json.partial! clip.reel, partial: 'api/v1/reels/reel', as: :reel
end
json.user do
  json.partial! clip.user, partial: 'api/v1/users/user', as: :user
end
json.created_at clip.created_at.to_time.to_i
