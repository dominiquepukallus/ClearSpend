Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  # root "pages#landing"
  # get "/home", to: "pages#home", as: :home

  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end

  unauthenticated :user do
    root to: "pages#landing", as: :unauthenticated_root
  end

  resources :subscriptions do
    collection do
      post :parse_csv
      post :import_csv
      post :bulk_create
    end
    resources :shared_subscriptions
  end
  resources :insights, only: [ :index ] do
    collection do
      post :generate
      post :regenerate
    end
  end
  resources :users, only: [ :show ]

  resources :shared_subscriptions, only: [:index] do
    member do
      patch :accept
      patch :reject
    end
  end

  resources :notifications do
    member do
      patch :accept
      patch :reject
    end
  end

  resources :chats do
    resources :messages, only: [:create]
  end

  resources :categories
  get "dashboard", to: "dashboard#index", as: :dashboard
end
