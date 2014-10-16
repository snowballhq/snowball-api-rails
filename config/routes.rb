Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'users/phone_authentication', to: 'users#phone_authentication', via: :post
      match 'users/me', to: 'users#show', via: :get
      resources :users, only: [:index]
    end
  end
end
