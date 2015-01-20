json.cache! clip do
  json.id clip.id
  json.video_url clip.video.url
  json.thumbnail_url clip.thumbnail.url
  json.user do
    json.partial! 'api/v1/users/user', user: clip.user
  end
  json.created_at clip.created_at.to_time.to_i
end
