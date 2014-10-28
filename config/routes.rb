Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'users/phone-auth', to: 'users#phone_auth', via: :post
      match 'users/:user_id/phone-verification', to: 'users#phone_verification', via: :post
      resources :users, only: [:index, :show, :update]
      resources :clips, only: :create
      match 'clips/feed', to: 'clips#index', via: :get
    end
  end
end
