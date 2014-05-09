Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :reels
      resources :clips
      match 'zencoder', to: 'zencoder#create', via: :post
    end
  end
end
