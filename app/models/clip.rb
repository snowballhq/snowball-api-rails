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

  def video_upload_url
    s3_url_string_for_file('video.mp4')
  end

  def thumbnail_upload_url
    s3_url_string_for_file('thumbnail.png')
  end

  private

  def s3_url_string_for_file(file)
    s3 = AWS::S3.new
    obj = s3.buckets[ENV['S3_BUCKET_NAME']].objects["clips/#{id}/#{file}"]
    obj.url_for(:write, acl: :public_read).to_s
  end
end
