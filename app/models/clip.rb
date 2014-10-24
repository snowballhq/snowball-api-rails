class Clip < ActiveRecord::Base
  has_attached_file :video

  validates :reel, presence: true
  validates :user, presence: true
  validates_attachment :video, presence: true, content_type: { content_type: 'video/mp4' }

  belongs_to :reel
  belongs_to :user
end
