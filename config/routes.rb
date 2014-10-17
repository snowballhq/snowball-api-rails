Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:index, :show, :update]
      match 'users/phone-auth/', to: 'users#phone_auth', via: :post
      # match 'users/phone-auth/verification
    end
  end
end
