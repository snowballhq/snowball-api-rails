class Clip < ActiveRecord::Base
  include Orderable
  include VideoEncoder

  belongs_to :reel
  belongs_to :user
  has_many :likes, as: :likeable

  validates :reel, presence: true
  validates :user, presence: true

  has_attached_file :video
  validates_attachment_presence :video
  validates_attachment_file_name :video, matches: [/mp4\Z/]

  after_create :encode_video

  def user_has_liked?(user)
    return true if user.liked.where(likeable: self).count > 0
    false
  end
end
