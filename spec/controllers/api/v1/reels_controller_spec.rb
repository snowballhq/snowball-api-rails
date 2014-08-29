require 'rails_helper'

describe Api::V1::ReelsController, type: :controller do
  let(:reel) { build :reel }
  let(:user) { create :user }
  let(:valid_attributes) { attributes_for(:reel).stringify_keys! }
  let(:invalid_attributes) { { name: nil } }

  before :each do
    login_api user.auth_token
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it_behaves_like 'a restricted api controller' do
    let(:action) { proc { get :index } }
  end

  describe 'GET index' do
    it 'assigns all reels that belong to the current user as @reels' do
      reel.participants << user
      reel.save!
      get :index, {}
      expect(assigns(:reels)).to eq([reel])
    end

    it 'does not assign reels that do not belong to the current user as @reels' do
      reel.save!
      get :index
      expect(assigns(:reels)).to_not eq([reel])
    end

    it 'is paginated' do
      26.times do
        reel = create :reel
        reel.participants << user
      end
      get :index, page: 1
      expect(assigns(:reels).count).to eq 25
      get :index, page: 2
      expect(assigns(:reels).count).to eq 1
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new reel' do
        expect do
          post :create, reel: valid_attributes
        end.to change(Reel, :count).by 1
      end
      it 'adds the current user as a participant' do
        expect(reel.participants).to eq []
        post :create, reel: valid_attributes
        expect(Reel.last.participants).to eq [user]
      end
      it 'adds all users specified in participant_ids as a participant' do
        user2 = create :user
        post :create, reel: valid_attributes.merge(participant_ids: [user2.id])
        expect(Reel.last.participants.count).to eq 2
      end
      it 'responds with a 201' do
        post :create, reel: valid_attributes
        expect(response.status).to eq 201
      end
    end
    describe 'with invalid params' do
      it 'raises an error' do
        bypass_rescue
        expect do
          post :create, reel: nil
        end.to raise_error
      end
    end
  end

  describe 'GET show' do
    it 'assigns the requested reel as @reel' do
      reel.save!
      get :show, id: reel
      expect(assigns(:reel)).to eq(reel)
    end
  end

  describe 'PUT update' do
    before :each do
      reel.save!
    end
    describe 'with valid params' do
      it 'updates the requested reel' do
        expect_any_instance_of(Reel).to receive(:update!).with(valid_attributes)
        put :update, id: reel, reel: valid_attributes
      end

      it 'renders json with the updated reel' do
        put :update, id: reel, reel: valid_attributes
        expect(response).to render_template :show
      end

      it 'does not allow the editing of participants' do
        user2 = create :user
        put :update, id: reel, reel: valid_attributes.merge(participant_ids: [user2.id])
        expect(reel.participants).to_not eq [user2]
      end
    end

    describe 'with invalid params' do
      it 'raises an error' do
        bypass_rescue
        expect do
          put :update, id: reel, reel: nil
        end.to raise_error
      end
    end
  end

end
