Rails.application.routes.draw do
  concern :api do
    namespace :v1, defaults: { format: :json } do
      match 'users/sign-in', to: 'users#sign_in', via: :post
      match 'users/sign-up', to: 'users#sign_up', via: :post
      match 'users/phone-search', to: 'users#phone_search', via: :post
      resources :users, only: [:index, :show, :update] do
        match '/followers', to: 'follows#followers', via: :get
        match '/following', to: 'follows#following', via: :get
        match '/follow', to: 'follows#create', via: :post
        match '/follow', to: 'follows#destroy', via: :delete
      end
      resources :clips, only: :create do
        resources :flags, only: :create
      end
      match 'clips/stream', to: 'clips#index', via: :get
    end
  end

  constraints subdomain: 'api' do
    namespace :api, path: nil do
      concerns :api
    end
  end
  namespace :api do
    concerns :api
  end
end
