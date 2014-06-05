Rails.application.routes.draw do
  devise_for :users, only: []
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'auth/:provider', to: 'sessions#create', via: :post
      match 'users/sign_in', to: 'sessions#create', via: :post
      match 'users/sign_up', to: 'registrations#create', via: :post
      resources :users, only: :show
      resources :clips, only: :create
      resources :reels do
        resources :clips, shallow: true do
          resources :likes, only: :create
          match 'likes', to: 'likes#destroy', via: :delete
        end
      end
      match 'zencoder', to: 'zencoder#create', via: :post
    end
  end
end
