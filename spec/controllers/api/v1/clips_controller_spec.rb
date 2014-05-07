require 'spec_helper'

describe Api::V1::ClipsController do
  let(:clip) { build :clip }
  let(:valid_attributes) { attributes_for(:clip).stringify_keys! }
  let(:valid_session) { {} }

  before :each do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET index' do
    it 'assigns all clips as @clips' do
      clip = Clip.create! valid_attributes
      get :index, {}, valid_session
      assigns(:clips).should eq([clip])
    end
  end

  describe 'GET show' do
    it 'assigns the requested clip as @clip' do
      clip = Clip.create! valid_attributes
      get :show, { id: clip.to_param }, valid_session
      assigns(:clip).should eq(clip)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new clip' do
        expect do
          post :create, { clip: valid_attributes }, valid_session
        end.to change(Clip, :count).by(1)
      end

      it 'renders json with the created clip' do
        post :create, { clip: valid_attributes }, valid_session
        expect(response.status).to eq 201
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do
      it "renders the clip errors" do
        Clip.any_instance.stub(:save).and_return(false)
        post :create, { clip: valid_attributes }, valid_session
        expect(response.status).to eq 422
        # expect(response.body).to eq clip.errors
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested clip' do
        clip = Clip.create! valid_attributes
        Clip.any_instance.should_receive(:update).with(valid_attributes)
        put :update, { id: clip.to_param, clip: valid_attributes }, valid_session
      end

      it 'renders json with the updated clip' do
        clip.save!
        put :update, { id: clip.to_param, clip: valid_attributes }, valid_session
        expect(response.status).to eq 200
        expect(response).to render_template :show
      end
    end

    describe 'with invalid params' do
      it "renders the clip errors" do
        clip.save!
        Clip.any_instance.stub(:save).and_return(false)
        put :update, { id: clip.to_param, clip: valid_attributes }, valid_session
        expect(response.status).to eq 422
        # expect(response.body).to eq clip.errors
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested clip' do
      clip.save!
      expect do
        delete :destroy, { id: clip.to_param }, valid_session
      end.to change(Clip, :count).by(-1)
    end

    it 'renders no content' do
      clip.save!
      delete :destroy, { id: clip.to_param }, valid_session
      expect(response.status).to eq 204
      expect(response.body.length).to eq 0
    end
  end

end
