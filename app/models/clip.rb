class Clip < ActiveRecord::Base
  has_attached_file :video
  validates_attachment_presence :video
  validates_attachment_content_type :video, content_type: 'video/mp4'
end
