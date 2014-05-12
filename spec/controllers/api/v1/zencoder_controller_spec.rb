require 'spec_helper'

describe Api::V1::ZencoderController do
  let(:clip) { build :clip }
  let(:valid_params) { { job: { id: 172151 } } }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'POST create' do
    before :each do
      clip.update(zencoder_job_id: 172151)
    end

    describe 'with valid params' do
      it 'finds the clip with the provided Zencoder job ID' do
        job_id = valid_params[:job][:id]
        expect(Clip).to receive(:where).with(zencoder_job_id: job_id).and_return([clip])
        post :create, valid_params
      end
      it 'updates the name of the encoded video and removes the Zencoder job ID' do
        expect_any_instance_of(Clip).to receive(:update).with(encoded_video_file_name: 'video.mp4', zencoder_job_id: nil)
        post :create, valid_params
      end
    end

    describe 'with invalid params' do
      it 'raises' do
        # TODO: finish this
      end
    end
  end
end
