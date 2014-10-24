Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'users/phone-auth', to: 'users#phone_auth', via: :post
      match 'users/:user_id/phone-verification', to: 'users#phone_verification', via: :post
      resources :users, only: [:index, :show, :update]
      resources :reels, only: [:index, :create, :update] do
        resources :participations, only: [:index, :create]
      end
      resources :participations, only: [:update, :destroy]
    end
  end
end
