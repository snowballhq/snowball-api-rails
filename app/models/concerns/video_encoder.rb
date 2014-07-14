module VideoEncoder
  extend ActiveSupport::Concern

  def encode_video
    # This method is not tested with Rspec. Please be careful!
    #
    # This method expects a paperclip video attribute 'video'
    # It also expects the model that implements this to have a column
    # named zencoder_job_id
    return if Rails.env.test?
    input_url = "s3://#{ENV['S3_BUCKET_NAME']}/#{video.path}"
    thumbnail_base_url = "s3://#{ENV['S3_BUCKET_NAME']}/#{thumbnail_path_without_filename}"
    output_url = "s3://#{ENV['S3_BUCKET_NAME']}/#{encoded_video_path}"
    response = Zencoder::Job.create(
      input: input_url,
      output: [
        {
          url: output_url,
          public: true,
          audio_bitrate: 64,
          audio_sample_rate: 44100,
          aspect_mode: :crop,
          video_bitrate: 700,
          format: :mp4,
          width: 640,
          height: 640,
          frame_rate: 24
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
            height: 640,
            public: true
          }]
        }
      ],
      notifications:
        if Rails.env.development?
          'http://zencoderfetcher/'
        else
          'http://snowball-production.herokuapp.com/api/v1/zencoder'
        end
    )
    self.zencoder_job_id = response.body['id']
    save!
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
    return unless video.path && video.path.length > 0
    url = 'https://' + ENV['S3_BUCKET_NAME'] +
    '.s3.amazonaws.com/' + thumbnail_path_without_filename
    url
  end

  def thumbnail_url
    thumbnail_base_url + thumbnail_filename + thumbnail_extension
  end

  def encoded_video_path
    video.path.sub('/original/', '/540p/')
  end

  def encoded_video_url
    return unless video.path && video.path.length > 0
    url = 'https://' + ENV['S3_BUCKET_NAME'] +
    '.s3.amazonaws.com/' + encoded_video_path
    url
  end
end
