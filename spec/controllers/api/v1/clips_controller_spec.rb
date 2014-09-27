require 'rails_helper'

describe Api::V1::ClipsController, type: :controller do
  let(:clip) { build :clip }
  let(:user) { create :user }
  let(:valid_request) { { reel_id: clip.reel.id } }
  let(:valid_attributes) { attributes_for(:clip).stringify_keys! }
  let(:invalid_attributes) { { video: nil } }

  before :each do
    login_api user.auth_token
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it_behaves_like 'a restricted api controller' do
    let(:action) { proc { get :index, reel_id: clip.reel } }
  end

  describe 'GET index' do
    it 'assigns all clips scoped to the reel id as @clips' do
      clip.save!
      get :index, valid_request
      expect(assigns(:clips)).to eq([clip])
    end

    describe 'when cursoring' do
      before :each do
        # doing this to create clips that are separated by date
        @clips = create_list(:clip, 12, reel: clip.reel)
        i = 0
        @clips.each do |c|
          c.created_at = c.created_at + i.days
          c.save!
          i += 1
        end
      end
      context 'with a since date' do
        it 'gets most recent 10 clips created after (including) the since date' do
          get :index, valid_request.merge(since_date: @clips.first.created_at.to_time.to_i)
          expect(assigns(:clips).count).to eq 10
          expect(assigns(:clips).first).to eq @clips[2]
          expect(assigns(:clips).last).to eq @clips[11]
        end
      end
      context 'with a max date' do
        it 'gets 10 clips created before (including) the max date' do
          # get :index, valid_request.merge(max_date: @clips.last.created_at.to_time.to_i)
          # expect(assigns(:clips).count).to eq 10
          # expect(assigns(:clips).last).to eq @clips.last
          # expect(assigns(:clips).first).to eq @clips[1]
        end
      end
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new clip' do
        expect do
          post :create, valid_request.merge(clip: valid_attributes)
        end.to change(Clip, :count).by(1)
      end

      it 'scopes the new clip to the current user' do
        post :create, valid_request.merge(clip: valid_attributes)
        expect(Clip.last.user_id).to eq user.id
      end

      it 'scopes the clip to the specified reel' do
        post :create, valid_request.merge(clip: valid_attributes)
        expect(Clip.last.reel).to eq(clip.reel)
      end

      it 'renders json with the created clip' do
        post :create, valid_request.merge(clip: valid_attributes)
        expect(response).to render_template :create
      end
    end

    describe 'with invalid params' do
      it 'raises ActiveRecord::RecordInvalid' do
        bypass_rescue
        expect do
          post :create, valid_request.merge(clip: invalid_attributes)
        end.to raise_error
      end
    end
  end

end
