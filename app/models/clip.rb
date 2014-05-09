class Clip < ActiveRecord::Base
  belongs_to :reel

  has_attached_file :video
  validates_attachment_presence :video
  validates_attachment_file_name :video, matches: [/mp4\Z/]

  after_create :encode_video

  private

  def encode_video
    unless Rails.env.test?
      response = Zencoder::Job.create(
        input: video_url,
        output: {
          width: '480',
          url: 's3://YOUR_S3_BUCKET/key_output.webm',
          notification: 'http://sharp-mountain-4005.herokuapp.com/zencoder/response'
        }
      )
    end
  end
end
