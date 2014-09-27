class Clip < ActiveRecord::Base
  include Orderable
  include Notifiable

  belongs_to :reel, touch: true
  belongs_to :user

  accepts_nested_attributes_for :reel

  validates :reel, presence: true
  validates :user, presence: true

  has_attached_file :video
  validates_attachment_presence :video
  validates_attachment_file_name :video, matches: [/mp4\Z/]

  def push_notification_message
    "#{user.username} added a clip to \"#{reel.friendly_name}\""
  end

  def video_url
    'https://' + ENV['S3_BUCKET_NAME'] + '.s3.amazonaws.com/' + video.path
  end
end
