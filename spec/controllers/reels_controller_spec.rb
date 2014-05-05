require 'spec_helper'

describe ReelsController do

  let(:valid_attributes) { {} }

  let(:valid_session) { {} }

  describe 'GET index' do
    it 'assigns all reels as @reels' do
      reel = Reel.create! valid_attributes
      get :index, {}, valid_session
      assigns(:reels).should eq([reel])
    end
  end

  describe 'GET show' do
    it 'assigns the requested reel as @reel' do
      reel = Reel.create! valid_attributes
      get :show, { id: reel.to_param }, valid_session
      assigns(:reel).should eq(reel)
    end
  end

  describe 'GET new' do
    it 'assigns a new reel as @reel' do
      get :new, {}, valid_session
      assigns(:reel).should be_a_new(Reel)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested reel as @reel' do
      reel = Reel.create! valid_attributes
      get :edit, { id: reel.to_param }, valid_session
      assigns(:reel).should eq(reel)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Reel' do
        expect do
          post :create, { reel: valid_attributes }, valid_session
        end.to change(Reel, :count).by(1)
      end

      it 'assigns a newly created reel as @reel' do
        post :create, { reel: valid_attributes }, valid_session
        assigns(:reel).should be_a(Reel)
        assigns(:reel).should be_persisted
      end

      it 'redirects to the created reel' do
        post :create, { reel: valid_attributes }, valid_session
        response.should redirect_to(Reel.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved reel as @reel' do
        Reel.any_instance.stub(:save).and_return(false)
        post :create, { reel: {} }, valid_session
        assigns(:reel).should be_a_new(Reel)
      end

      it "re-renders the 'new' template" do
        Reel.any_instance.stub(:save).and_return(false)
        post :create, { reel: {} }, valid_session
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested reel' do
        reel = Reel.create! valid_attributes
        Reel.any_instance.should_receive(:update).with('these' => 'params')
        put :update, { id: reel.to_param, reel: { 'these' => 'params' } }, valid_session
      end

      it 'assigns the requested reel as @reel' do
        reel = Reel.create! valid_attributes
        put :update, { id: reel.to_param, reel: valid_attributes }, valid_session
        assigns(:reel).should eq(reel)
      end

      it 'redirects to the reel' do
        reel = Reel.create! valid_attributes
        put :update, { id: reel.to_param, reel: valid_attributes }, valid_session
        response.should redirect_to(reel)
      end
    end

    describe 'with invalid params' do
      it 'assigns the reel as @reel' do
        reel = Reel.create! valid_attributes
        Reel.any_instance.stub(:save).and_return(false)
        put :update, { id: reel.to_param, reel: {} }, valid_session
        assigns(:reel).should eq(reel)
      end

      it "re-renders the 'edit' template" do
        reel = Reel.create! valid_attributes
        Reel.any_instance.stub(:save).and_return(false)
        put :update, { id: reel.to_param, reel: {} }, valid_session
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested reel' do
      reel = Reel.create! valid_attributes
      expect do
        delete :destroy, { id: reel.to_param }, valid_session
      end.to change(Reel, :count).by(-1)
    end

    it 'redirects to the reels list' do
      reel = Reel.create! valid_attributes
      delete :destroy, { id: reel.to_param }, valid_session
      response.should redirect_to(reels_url)
    end
  end

end
