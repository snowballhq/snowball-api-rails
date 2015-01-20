class Clip < ActiveRecord::Base
  include Orderable

  has_attached_file :video
  has_attached_file :thumbnail

  validates :user, presence: true
  validates_attachment :video, presence: true, content_type: { content_type: 'video/mp4' }
  validates_attachment :thumbnail, presence: true, content_type: { content_type: 'image/png' }

  belongs_to :user
  has_many :flags
end
