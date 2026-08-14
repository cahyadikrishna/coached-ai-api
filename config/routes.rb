Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Strava OAuth
  get "auth/strava", to: "sessions#connect"
  get "auth/strava/callback", to: "sessions#strava_callback"

  resources :activities, only: %i[index show]
  resources :weekly_summaries, only: %i[index create]

  post "recommendations", to: "recommendations#create"

  # Defines the root path route ("/")
  # root "posts#index"
end
