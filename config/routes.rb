Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'users/sign-in', to: 'users#sign_in', via: :post
      match 'users/sign-up', to: 'users#sign_up', via: :post
      match 'users/phone-auth', to: 'users#phone_auth', via: :post
      resources :users, only: [:index, :show, :update] do
        match '/phone-verification', to: 'users#phone_verification', via: :post
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
end
