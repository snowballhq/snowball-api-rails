json.clip do
  json.partial! @clip, partial: 'api/v1/clips/clip', as: :clip
end
