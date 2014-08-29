Rails.application.routes.draw do
  root to: 'static#home'
  devise_for :users, only: []
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'users/sign_in', to: 'sessions#create', via: :post
      match 'users/sign_up', to: 'registrations#create', via: :post
      match 'auth/:provider', to: 'sessions#create', via: :post
      resources :users, only: [:show, :update] do
        match 'following', to: 'follows#following', via: :get
        match 'followers', to: 'follows#followers', via: :get
        match 'follow', to: 'follows#create', via: :post
        match 'follow', to: 'follows#destroy', via: :delete
      end
      match 'users/find_by_contacts', to: 'users#find_by_contacts', via: :post
      resources :clips, only: :destroy
      resources :reels, only: [:index, :create, :show, :update] do
        match 'participants', to: 'participations#index', via: :get
        match 'participants/:user_id', to: 'participations#create', via: :post
        match 'participants/:user_id', to: 'participations#destroy', via: :delete
        resources :clips, only: [:index, :create]
      end
      match 'zencoder', to: 'zencoder#create', via: :post
    end
  end
end
