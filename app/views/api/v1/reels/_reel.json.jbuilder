json.id reel.id
json.name reel.name
json.recent_participants_names reel.recent_participants_names
json.thumbnail_url reel.encoded_clips.last.thumbnail_url
json.last_clip_created_at reel.encoded_clips.last.created_at.to_time.to_i
