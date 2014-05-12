class Api::V1::ZencoderController < Api::V1::ApiController
  def create
    job_id = job_params[:id].to_i
    clip = Clip.where(zencoder_job_id: job_id).first
    # video.mp4 is set in the video encoder as the output filename
    clip.update(encoded_video_file_name: 'video.mp4', zencoder_job_id: nil)
    head :ok
  end

  private

  def job_params
    params.require(:job).permit(:id)
  end
end
