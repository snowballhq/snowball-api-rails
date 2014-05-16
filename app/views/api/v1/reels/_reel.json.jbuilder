json.id reel.id
json.name reel.name
json.recent_clips reel.clips.last(5) do |clip|
  json.id clip.id
  json.poster_url clip.thumbnail_url
  json.user do
    json.id clip.user.id
  end
end