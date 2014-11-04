Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'users/phone-auth', to: 'users#phone_auth', via: :post
      resources :users, only: [:index, :show, :update] do
        match '/phone-verification', to: 'users#phone_verification', via: :post
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
end
