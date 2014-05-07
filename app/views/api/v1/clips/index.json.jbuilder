json.clips do
  json.partial! collection: @clips, partial: 'api/v1/clips/clip', as: :clip
end
