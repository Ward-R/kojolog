Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  # Defines the root path route ("/")
  root "pages#home"

  resources :logs, only: [:index, :show]

  resources :users, only: [:index, :show] do
    resources :logs, only: [:index], controller: 'users/logs'
  end

  resources :units do
    resources :logs, shallow: true, except: [:destroy] do
      resources :log_entries, only: [:create, :index]
      resources :sign_offs, only: [:new, :create]
    end
    # resources :templates here later
  end


  # resources :standing_orders
  # resources :competency_records

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
