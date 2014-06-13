require 'spec_helper'
require 'controllers/shared_controller_behaviors'

describe Api::V1::FollowsController do
  let(:follow) { build :follow }

  before :each do
    login_api follow.user.auth_token
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it_behaves_like 'a restricted api controller' do
    let(:action) { proc { post :create, user_id: follow.followable } }
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new follow' do
        expect do
          post :create, user_id: follow.followable
        end.to change(Follow, :count).by 1
      end

      it 'doesn\'t create a follow if user has already followed followable' do
        expect do
          post :create, user_id: follow.followable
        end.to change(Follow, :count).by 1
        expect do
          post :create, user_id: follow.followable
        end.to_not change(Follow, :count).by 1
      end

      it 'renders created' do
        post :create, user_id: follow.followable.id
        expect(response.status).to eq 201
        expect(response.body.length).to eq 1
      end
    end

    describe 'with invalid params' do
      it 'raises an error' do
        expect do
          bypass_rescue
          post :create, follow: {}
        end.to raise_error
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      follow.save!
    end
    it 'destroys the requested follow' do
      expect do
        delete :destroy, user_id: follow.followable.id
      end.to change(Follow, :count).by(-1)
    end

    it 'returns a 204 with an empty body' do
      delete :destroy, user_id: follow.followable.id
      expect(response.status).to eq 204
      expect(response.body.length).to eq 0
    end
  end
end
