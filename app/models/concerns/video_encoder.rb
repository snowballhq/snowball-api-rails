module VideoEncoder
  extend ActiveSupport::Concern

  def encode_video
    # This method is not tested with Rspec. Please be careful!
    #
    # This method expects a paperclip video, not a URL
    # It also expects the model that implements this to have a column
    # named zencoder_job_id
    unless Rails.env.test?
      input_url = "s3://#{ENV['S3_ORIGINAL_CLIPS_BUCKET_NAME']}/#{video.path}"
      output_url = "s3://#{ENV['S3_ENCODED_CLIPS_BUCKET_NAME']}/#{video.path}"
      response = Zencoder::Job.create(
        input: input_url,
        output: {
          url: output_url,
          audio_bitrate: 56,
          audio_sample_rate: 22050,
          aspect_mode: :crop,
          video_bitrate: 1500,
          format: :mp4,
          height: 540,
          width: 960
        },
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

  def encoded_video_url
    if video.path && video.path.length > 0 && encoded_video_file_name && encoded_video_file_name.length > 0
      url = 'https://' + ENV['S3_ENCODED_CLIPS_BUCKET_NAME'] +
        '.s3.amazonaws.com/' + video.path
      url
    end
  end
end
