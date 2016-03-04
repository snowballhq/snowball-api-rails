Rails.application.routes.draw do
  scope 'v1', defaults: { format: :json } do
    match 'users/sign-in', to: 'sessions#create', via: :post
    match 'users/sign-up', to: 'registrations#create', via: :post
    match 'users/phone-search', to: 'users#phone_search', via: :post
    resources :users, only: [:index, :show, :update] do
      match '/followers', to: 'follows#followers', via: :get
      match '/following', to: 'follows#following', via: :get
      match '/follow', to: 'follows#create', via: :post
      match '/follow', to: 'follows#destroy', via: :delete
    end
    resources :clips, only: [:create, :destroy] do
      resources :flags, only: :create
      match '/likes', to: 'likes#create', via: :post
      match '/likes', to: 'likes#destroy', via: :delete
    end
    match 'users/:user_id/clips/stream', to: 'clips#index', via: :get
    match 'clips/stream', to: 'clips#index', via: :get
    resources :devices, only: :create
  end
end
