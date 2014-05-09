class Api::V1::ZencoderController < Api::V1::ApiController
  def create
    job_id = job_params[:id].to_i
    clip = Clip.where(zencoder_job_id: job_id).first
    # playlist.m3u8 is set in the HLS encoder as the output filename
    clip.update(video_hls_index_file_name: 'playlist.m3u8', zencoder_job_id: nil)
    head :ok
  end

  private

  def job_params
    params.require(:job).permit(:id)
  end
end
