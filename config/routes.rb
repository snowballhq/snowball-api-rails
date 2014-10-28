Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'users/phone-auth', to: 'users#phone_auth', via: :post
      resources :users, only: [:index, :show, :update] do
        match '/phone-verification', to: 'users#phone_verification', via: :post
        resources :follows, only: :create
        match '/follows', to: 'follows#destroy', via: :delete
      end
      resources :clips, only: :create
      match 'clips/feed', to: 'clips#index', via: :get
    end
  end
end
