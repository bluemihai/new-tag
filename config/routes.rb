Rails.application.routes.draw do
  resources :insights
  resources :aktions do
    collection { get :continue, :start }
  end
  resources :role_assignments
  resources :project_memberships
  resources :team_memberships do
    member { get :update_from_api }
  end
  resources :locations, :verbs
  resources :players do
    resources :aktions
  end
  resources :teams do
    member { get :join, :leave }
    resources :projects
    resources :roles
  end

  resources :roles
  resources :projects

  root to: 'visitors#index'
  get '/welcome' => 'visitors#welcome'
  get '/help' => 'visitors#help'
  get '/sounds' => 'visitors#sounds'
  get '/scores' => 'visitors#scores'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
