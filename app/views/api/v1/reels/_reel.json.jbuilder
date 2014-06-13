json.id reel.id
json.name reel.name
json.updated_at reel.updated_at.to_time.to_i
json.recent_clips reel.clips.last(5) do |clip|
  json.id clip.id
  json.poster_url clip.thumbnail_url
  json.created_at clip.created_at.to_time.to_i
  json.user do
    json.id clip.user.id
  end
end
