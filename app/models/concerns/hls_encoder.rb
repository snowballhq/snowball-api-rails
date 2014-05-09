module HLSEncoder
  extend ActiveSupport::Concern

  def hls_encode_video(video)
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
        output: [
          { # Audio Only
            audio_bitrate: 56,
            audio_sample_rate: 22050,
            base_url: output_url,
            filename: 'file-64k.m3u8',
            format: :aac,
            public: 1,
            type: :segmented
          },
          { # Video 400x225
            audio_bitrate: 56,
            audio_sample_rate: 22050,
            base_url: output_url,
            decoder_bitrate_cap: 300,
            decoder_buffer_size: 800,
            filename: 'file-240k.m3u8',
            max_frame_rate: 15,
            public: 1,
            type: :segmented,
            aspect_mode: :crop,
            video_bitrate: 200,
            width: 400,
            height: 225,
            format: :ts
          },
          { # Video 400x225
            audio_bitrate: 56,
            audio_sample_rate: 22050,
            base_url: output_url,
            decoder_bitrate_cap: 600,
            decoder_buffer_size: 1600,
            filename: 'file-440k.m3u8',
            public: 1,
            type: :segmented,
            aspect_mode: :crop,
            video_bitrate: 400,
            width: 400,
            height: 225,
            format: :ts
          },
          { # Video 480x270
            audio_bitrate: 56,
            audio_sample_rate: 22050,
            base_url: output_url,
            decoder_bitrate_cap: 900,
            decoder_buffer_size: 2400,
            filename: 'file-640k.m3u8',
            public: 1,
            type: :segmented,
            aspect_mode: :crop,
            video_bitrate: 600,
            width: 480,
            height: 270,
            format: :ts
          },
          { # Video 640x360
            audio_bitrate: 56,
            audio_sample_rate: 22050,
            base_url: output_url,
            decoder_bitrate_cap: 1500,
            decoder_buffer_size: 4000,
            filename: 'file-1040k.m3u8',
            public: 1,
            type: :segmented,
            aspect_mode: :crop,
            video_bitrate: 1000,
            width: 640,
            height: 360,
            format: :ts
          },
          { # Video 960x540
            audio_bitrate: 56,
            audio_sample_rate: 22050,
            base_url: output_url,
            decoder_bitrate_cap: 2250,
            decoder_buffer_size: 6000,
            filename: 'file-1540k.m3u8',
            public: 1,
            type: :segmented,
            aspect_mode: :crop,
            video_bitrate: 1500,
            width: 960,
            height: 540,
            format: :ts
          },
          { # Video 1024x576
            audio_bitrate: 56,
            audio_sample_rate: 22050,
            base_url: output_url,
            decoder_bitrate_cap: 3000,
            decoder_buffer_size: 8000,
            filename: 'file-2040k.m3u8',
            public: 1,
            type: :segmented,
            aspect_mode: :crop,
            video_bitrate: 2000,
            width: 1024,
            height: 576,
            format: :ts
          },
          { # Playlist Generation
            # The first entry in the variant playlist is played when a user
            # joins the stream and is used as part of a test to determine which
            # stream is most appropriate. The order of the other entries is
            # irrelevant.
            # From Apple's HTTP Live Streaming Overview, Stream Alternates
            base_url: output_url,
            filename: 'playlist.m3u8',
            public: 1,
            streams: [
              { # Video 1024x576
                bandwidth: 2040,
                path: 'file-2040k.m3u8'
              },
              { # Video 960x540
                bandwidth: 1540,
                path: 'file-1540k.m3u8'
              },
              { # Video 640x360
                bandwidth: 1040,
                path: 'file-1040k.m3u8'
              },
              { # Video 480x270
                bandwidth: 640,
                path: 'file-640k.m3u8'
              },
              { # Video 400x225
                bandwidth: 440,
                path: 'file-440k.m3u8'
              },
              { # Video 400x225
                bandwidth: 240,
                path: 'file-240k.m3u8'
              },
              { # Audio Only
                bandwidth: 64,
                path: 'file-64k.m3u8'
              }
          ],
            type: 'playlist'
          }
        ],
        notifications: [
          if Rails.env.development?
            'http://zencoderfetcher/'
          else
            api_v1_zencoder_url
          end
        ]
      )
      self.zencoder_job_id = response.body['id']
      self.save!
    end
  end

  def video_hls_index_url
    url = 'https://' + ENV['S3_ENCODED_CLIPS_BUCKET_NAME'] +
      '.s3.amazonaws.com/' + video.path + '/' +
      video_hls_index_file_name
    url
  end
end
