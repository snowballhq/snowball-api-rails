Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :reels do
        resources :clips, shallow: true
      end
      match 'zencoder', to: 'zencoder#create', via: :post
    end
  end
end
