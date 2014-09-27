json.id reel.id
json.title reel.title
json.participants_title reel.recent_participants_names
if controller_name == 'reels' && action_name == 'index'
  json.recent_clip do
    json.partial! reel.clips.last, partial: 'api/v1/clips/clip', as: :clip
  end
end
