json.id clip.id
json.video_url clip.video.url
json.thumbnail_url clip.thumbnail.url
json.user do
  json.partial! 'users/user', user: clip.user
end
json.liked 0 < clip.likes.where(user: current_user).count
json.created_at clip.created_at.to_time.to_i
