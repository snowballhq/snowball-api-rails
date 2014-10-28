class Clip < ActiveRecord::Base
  include Orderable

  has_attached_file :video

  validates :user, presence: true
  validates_attachment :video, presence: true, content_type: { content_type: 'video/mp4' }

  belongs_to :user
end
