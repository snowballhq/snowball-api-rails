json.id reel.id
json.name reel.name
json.recent_participants_names reel.recent_participants_names
json.last_clip do
  json.partial! reel.encoded_clips.last, partial: 'api/v1/clips/clip', as: :clip
end
