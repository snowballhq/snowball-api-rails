json.array!(@reels) do |reel|
  json.extract! reel, :id
  json.url reel_url(reel, format: :json)
end
