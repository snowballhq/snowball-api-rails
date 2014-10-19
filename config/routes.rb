Rails.application.routes.draw do
  resources :participations

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'users/phone-auth', to: 'users#phone_auth', via: :post
      match 'users/:user_id/phone-verification', to: 'users#phone_verification', via: :post
      resources :users, only: [:index, :show, :update]
      resources :reels, only: [:index, :create, :update]
    end
  end
end
