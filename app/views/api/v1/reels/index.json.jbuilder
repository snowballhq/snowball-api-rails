json.reels do
  json.partial! collection: @reels, partial: 'api/v1/reels/reel', as: :reel
end
