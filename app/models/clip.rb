class Clip < ActiveRecord::Base
  include Orderable
  include Notifiable
  include VideoEncoder

  belongs_to :reel, touch: true
  belongs_to :user

  validates :reel, presence: true
  validates :user, presence: true

  has_attached_file :video
  validates_attachment_presence :video
  validates_attachment_file_name :video, matches: [/mp4\Z/]

  after_create :encode_video

  def zencoder_job_id=(value)
    create_notification if value.nil?
    self[:zencoder_job_id] = value
  end

  def push_notification_message
    "#{user.username} added a clip to \"#{reel.friendly_name}\""
  end
end
