Rails.application.routes.draw do
  root to: 'static#home'
  devise_for :users, only: []
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Authentication
      match 'users/sign_in', to: 'sessions#create', via: :post
      match 'users/sign_up', to: 'registrations#create', via: :post
      match 'auth/:provider', to: 'sessions#create', via: :post
      # User
      resources :users, only: [:show, :update] do
        match 'following', to: 'follows#following', via: :get
        match 'follow', to: 'follows#create', via: :post
        match 'follow', to: 'follows#destroy', via: :delete
      end
      match 'users/find_by_contacts', to: 'users#find_by_contacts', via: :post
      # Reel
      match 'reels/stream', to: 'reels#index', via: :get
      resources :reels, only: [:create, :update] do
        match 'participants', to: 'participations#index', via: :get
        match 'participants/:user_id', to: 'participations#create', via: :post
        match 'participants/:user_id', to: 'participations#destroy', via: :delete
        # Clip
        resources :clips, only: [:index, :create]
      end
    end
  end
end
