Rails.application.routes.draw do
  root "users#new"
  resources :articles
  get "signup", to: "users#new"
  resources :users, except: [ :new ]
  get "login", to: "session#new"
  post "login", to: "session#create"
  delete "logout", to: "session#destroy", as: :logout
  resources :categories, except: [ :destroy ]

  get "up" => "rails/health#show", as: :rails_health_check
end
