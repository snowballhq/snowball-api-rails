json.cache! clip do
  json.id clip.id
  json.reel_id clip.reel.id
  json.video_url clip.video.url
  json.user do
    json.partial! 'api/v1/users/user', user: clip.user
  end
  json.created_at clip.created_at.to_time.to_i
end
