class Clip < ActiveRecord::Base
  include Orderable

  has_attached_file :video, use_timestamp: false
  has_attached_file :thumbnail

  validates :user, presence: true
  validates_attachment :video, content_type: { content_type: 'video/mp4' }
  validates_attachment :thumbnail, content_type: { content_type: 'image/png' }

  belongs_to :user
  has_many :flags, dependent: :destroy
  has_many :likes, dependent: :destroy
end
