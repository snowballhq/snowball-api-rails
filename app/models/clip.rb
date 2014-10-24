class Clip < ActiveRecord::Base
  include Orderable

  has_attached_file :video

  validates :reel, presence: true
  validates :user, presence: true
  validates_attachment :video, presence: true, content_type: { content_type: 'video/mp4' }

  belongs_to :reel
  belongs_to :user
  has_many :participations, foreign_key: :last_watched_clip_id
end
