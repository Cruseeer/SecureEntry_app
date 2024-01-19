Rails.application.routes.draw do
  root 'home#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy', as: :logout

  get 'signup', to: 'registrations#new'
  post 'signup', to: 'registrations#create'

  post '/report_lost_card', to: 'home#report_lost_card'

  get '/lost_cards/all_lost_cards', to: 'lost_cards#all_lost_cards'
  get '/lost_cards/all_lost_cards', to: 'lost_cards#all_lost_cards', as: 'all_lost_cards'

  namespace :admin do
    get 'users/new', to: 'users#new', as: 'new_admin_user'
    post 'users', to: 'users#create', as: 'admin_users_path'
    get 'users/:id/edit', to: 'users#edit', as: 'edit_admin_user'
  end


  resources :logs
  resources :lost_cards
  resources :rooms
  resources :users
  resources :registrations, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    resources :users, only: [:new, :create, :index, :edit]
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
