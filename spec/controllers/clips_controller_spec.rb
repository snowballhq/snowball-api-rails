require 'spec_helper'

describe ClipsController do

  let(:valid_attributes) { {} }

  let(:valid_session) { {} }

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

  describe 'GET new' do
    it 'assigns a new clip as @clip' do
      get :new, {}, valid_session
      assigns(:clip).should be_a_new(Clip)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested clip as @clip' do
      clip = Clip.create! valid_attributes
      get :edit, { id: clip.to_param }, valid_session
      assigns(:clip).should eq(clip)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Clip' do
        expect do
          post :create, { clip: valid_attributes }, valid_session
        end.to change(Clip, :count).by(1)
      end

      it 'assigns a newly created clip as @clip' do
        post :create, { clip: valid_attributes }, valid_session
        assigns(:clip).should be_a(Clip)
        assigns(:clip).should be_persisted
      end

      it 'redirects to the created clip' do
        post :create, { clip: valid_attributes }, valid_session
        response.should redirect_to(Clip.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved clip as @clip' do
        Clip.any_instance.stub(:save).and_return(false)
        post :create, { clip: {} }, valid_session
        assigns(:clip).should be_a_new(Clip)
      end

      it "re-renders the 'new' template" do
        Clip.any_instance.stub(:save).and_return(false)
        post :create, { clip: {} }, valid_session
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested clip' do
        clip = Clip.create! valid_attributes
        Clip.any_instance.should_receive(:update).with('these' => 'params')
        put :update, { id: clip.to_param, clip: { 'these' => 'params' } }, valid_session
      end

      it 'assigns the requested clip as @clip' do
        clip = Clip.create! valid_attributes
        put :update, { id: clip.to_param, clip: valid_attributes }, valid_session
        assigns(:clip).should eq(clip)
      end

      it 'redirects to the clip' do
        clip = Clip.create! valid_attributes
        put :update, { id: clip.to_param, clip: valid_attributes }, valid_session
        response.should redirect_to(clip)
      end
    end

    describe 'with invalid params' do
      it 'assigns the clip as @clip' do
        clip = Clip.create! valid_attributes
        Clip.any_instance.stub(:save).and_return(false)
        put :update, { id: clip.to_param, clip: {} }, valid_session
        assigns(:clip).should eq(clip)
      end

      it "re-renders the 'edit' template" do
        clip = Clip.create! valid_attributes
        Clip.any_instance.stub(:save).and_return(false)
        put :update, { id: clip.to_param, clip: {} }, valid_session
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested clip' do
      clip = Clip.create! valid_attributes
      expect do
        delete :destroy, { id: clip.to_param }, valid_session
      end.to change(Clip, :count).by(-1)
    end

    it 'redirects to the clips list' do
      clip = Clip.create! valid_attributes
      delete :destroy, { id: clip.to_param }, valid_session
      response.should redirect_to(clips_url)
    end
  end

end
