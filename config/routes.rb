Rails.application.routes.draw do
  devise_for :users
  resources :tasks, except: [:index]
  resources :lists
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "lists#index"

  post '/ai_image_email', to: 'tasks#ai_image_email'
end
