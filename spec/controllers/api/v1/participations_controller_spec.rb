require 'rails_helper'

describe Api::V1::ParticipationsController, type: :controller do
  let(:reel) { create :reel }
  let(:user) { create :user }
  let(:valid_request) { { reel_id: reel } }
  let(:valid_attributes) { { id: user.id } }

  before :each do
    login_api user.auth_token
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it_behaves_like 'a restricted api controller' do
    let(:action) { proc { get :index, valid_request } }
  end

  describe 'GET index' do
    it 'assigns all participants for the reel as @participants' do
      reel.participants << user
      get :index, valid_request
      expect(assigns(:participants)).to eq([user])
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new participant' do
        expect do
          post :create, valid_request.merge(user: valid_attributes)
        end.to change(Participation, :count).by 1
      end
      it 'responds with a 201' do
        post :create, valid_request.merge(user: valid_attributes)
        expect(response.status).to eq 201
      end
    end
    describe 'with invalid params' do
      it 'raises an error' do
        bypass_rescue
        expect do
          post :create, valid_request.merge(user: {} )
        end.to raise_error
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      reel.participants << user
    end
    it 'destroys the requested participation' do
      expect do
        delete :destroy, valid_request.merge(id: user)
      end.to change(Participation, :count).by -1
    end
    it 'renders a 204' do
      delete :destroy, valid_request.merge(id: user)
      expect(response.status).to eq 204
      expect(response.body.length).to eq 0
    end
  end
end
