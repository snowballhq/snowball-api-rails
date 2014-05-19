require 'spec_helper'
require 'controllers/shared_controller_behaviors'

describe Api::V1::LikesController do
  let(:like) { build :like }

  before :each do
    login_api like.user.auth_token
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it_behaves_like 'a restricted api controller' do
    let(:action) { proc { post :create, clip_id: like.likeable } }
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new like' do
        expect do
          post :create, clip_id: like.likeable
        end.to change(Like, :count).by 1
      end

      it 'doesn\'t create a like if user has already liked likeable' do
        expect do
          post :create, clip_id: like.likeable
        end.to change(Like, :count).by 1
        expect do
          post :create, clip_id: like.likeable
        end.to_not change(Like, :count).by 1
      end

      it 'renders created' do
        post :create, clip_id: like.likeable.id
        expect(response.status).to eq 201
        expect(response.body.length).to eq 1
      end
    end

    describe 'with invalid params' do
      it 'raises an error' do
        expect do
          bypass_rescue
          post :create, like: {}
        end.to raise_error
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      like.save!
    end
    it 'destroys the requested like' do
      expect do
        delete :destroy, clip_id: like.likeable.id
      end.to change(Like, :count).by(-1)
    end

    it 'returns a 204 with an empty body' do
      delete :destroy, clip_id: like.likeable.id
      expect(response.status).to eq 204
      expect(response.body.length).to eq 0
    end
  end
end
