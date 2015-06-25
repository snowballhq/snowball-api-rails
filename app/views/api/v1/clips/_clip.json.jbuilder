json.id clip.id
if clip.video.exists?
  json.video_url clip.video.url
  json.thumbnail_url clip.thumbnail.url
else
  json.video_upload_url 'aurl'
  json.thumbnail_upload_url 'aurl'
end
json.user do
  json.partial! 'api/v1/users/user', user: clip.user
end
json.liked 0 < clip.likes.where(user: current_user).count
json.created_at clip.created_at.to_time.to_i
