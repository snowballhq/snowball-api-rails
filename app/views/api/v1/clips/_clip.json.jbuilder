json.id clip.id
json.video_url clip.encoded_video_url
json.liked clip.user_has_liked?(current_user)
json.reel do
  json.id clip.reel.id
  json.name clip.reel.name
end
json.user do
  json.id clip.user.id
  json.username clip.user.username
end
json.created_at clip.created_at.to_time.to_i