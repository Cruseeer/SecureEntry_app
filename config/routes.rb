Rails.application.routes.draw do
  root 'home#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy', as: :logout

  get 'signup', to: 'registrations#new'
  post 'signup', to: 'registrations#create'

  resources :logs
  resources :lost_cards
  resources :rooms
  resources :users
  resources :registrations, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
