module VideoEncoder
  extend ActiveSupport::Concern

  def encode_video
    # This method is not tested with Rspec. Please be careful!
    #
    # This method expects a paperclip video attribute 'video'
    # It also expects the model that implements this to have a column
    # named zencoder_job_id
    unless Rails.env.test?
      input_url = "s3://#{ENV['S3_BUCKET_NAME']}/#{video.path}"
      thumbnail_base_url = "s3://#{ENV['S3_BUCKET_NAME']}/#{thumbnail_path_without_filename}"
      output_url = "s3://#{ENV['S3_BUCKET_NAME']}/#{encoded_video_path}"
      response = Zencoder::Job.create(
        input: input_url,
        output: [
          {
            url: output_url,
            public: true,
            audio_bitrate: 56,
            audio_sample_rate: 22050,
            aspect_mode: :crop,
            video_bitrate: 1500,
            format: :mp4,
            width: 960,
            height: 540
          },
          {
            thumbnails: [{
              base_url: thumbnail_base_url,
              filename: thumbnail_filename,
              label: thumbnail_filename,
              number: 1,
              format: :png,
              aspect_mode: :crop,
              width: 640,
              height: 360,
              public: true
            }]
          }
        ],
        notifications:
          if Rails.env.development?
            'http://zencoderfetcher/'
          else
            api_v1_zencoder_url
          end
      )
      self.zencoder_job_id = response.body['id']
      save!
    end
  end

  def thumbnail_filename
    '640x360'
  end

  def thumbnail_extension
    '.png'
  end

  def thumbnail_path_without_filename
    thumbnail_path = video.path.sub('/original/', '/thumbnails/')
    thumbnail_path.sub(video.original_filename, '')
  end

  def thumbnail_base_url
    if video.path && video.path.length > 0
      url = 'https://' + ENV['S3_BUCKET_NAME'] +
        '.s3.amazonaws.com/' + thumbnail_path_without_filename
      url
    end
  end

  def thumbnail_url
    thumbnail_base_url + thumbnail_filename + thumbnail_extension
  end

  def encoded_video_path
    video.path.sub('/original/', '/540p/')
  end

  def encoded_video_url
    if video.path && video.path.length > 0
      url = 'https://' + ENV['S3_BUCKET_NAME'] +
        '.s3.amazonaws.com/' + encoded_video_path
      url
    end
  end
end
