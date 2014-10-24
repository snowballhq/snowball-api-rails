json.cache! reel do
  json.id reel.id
  json.title reel.title
  json.users_title reel.users_title
  clip = reel.next_clip(@current_user)
  if clip
    json.next_clip do
      json.partial! 'api/v1/clips/clip', clip: clip
    end
  else
    json.next_clip nil
  end
end
