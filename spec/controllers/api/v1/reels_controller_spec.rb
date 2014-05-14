require 'spec_helper'

describe Api::V1::ReelsController do
  let(:reel) { build :reel }
  let(:valid_attributes) { attributes_for(:reel).stringify_keys! }
  let(:invalid_attributes) { { name: nil } }
  let(:valid_session) { {} }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET index' do
    it 'assigns all reels as @reels' do
      reel.save!
      get :index, {}, valid_session
      assigns(:reels).should eq([reel])
    end

    it 'is paginated' do
      create_list(:reel, 26)
      get :index, { page: 1 }, valid_session
      expect(assigns(:reels).count).to eq 25
      get :index, { page: 2 }, valid_session
      expect(assigns(:reels).count).to eq 1
    end
  end

  describe 'GET show' do
    it 'assigns the requested reel as @reel' do
      reel.save!
      get :show, { id: reel }, valid_session
      assigns(:reel).should eq(reel)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new reel' do
        expect do
          post :create, { reel: valid_attributes }, valid_session
        end.to change(Reel, :count).by(1)
      end

      it 'renders json with the created reel' do
        post :create, { reel: valid_attributes }, valid_session
        expect(response.status).to eq 201
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do
      it 'raises ActiveRecord::RecordInvalid' do
        bypass_rescue
        expect do
          post :create, { reel: invalid_attributes }, valid_session
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe 'PUT update' do
    before :each do
      reel.save!
    end
    describe 'with valid params' do
      it 'updates the requested reel' do
        Reel.any_instance.should_receive(:update!).with(valid_attributes)
        put :update, { id: reel, reel: valid_attributes }, valid_session
      end

      it 'renders json with the updated reel' do
        put :update, { id: reel, reel: valid_attributes }, valid_session
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do
      it 'raises ActiveRecord::RecordInvalid' do
        bypass_rescue
        expect do
          put :update, { id: reel, reel: invalid_attributes }, valid_session
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      reel.save!
    end
    it 'destroys the requested reel' do
      expect do
        delete :destroy, { id: reel }, valid_session
      end.to change(Reel, :count).by(-1)
    end

    it 'renders no content' do
      delete :destroy, { id: reel }, valid_session
      expect(response.status).to eq 204
      expect(response.body.length).to eq 0
    end
  end

end
