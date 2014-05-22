json.id clip.id
json.video_url clip.encoded_video_url
json.reel clip.reel do |reel|
  json.id reel.id
  json.name reel.name
end
json.user clip.user do |user|
  json.id user.id
  json.username user.username
end
json.created_at clip.created_at.to_time.to_i