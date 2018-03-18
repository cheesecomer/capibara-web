Rails.application.routes.draw do
  devise_for :users, only: []

  devise_scope :user do
    authenticated :user do
      root to: 'rooms#index', as: :authenticated_root
    end
    root to: 'sessions#new'
    resource :session, only: [:new, :create, :destroy], controller: :sessions
    resource :users, only: [:new, :create], controller: :user_registrations
    get '/session', to: 'sessions#new'
  end

  resources :rooms
  resources :users, only: [:show]

  namespace :api, defaults: { format: :json } do
    resource :session, only: [:create, :destroy], controller: :sessions
    resources :rooms, only: [:index, :show]
    resources :informations, only: [:index]
    resources :users, only: [:create, :update, :show]
    resource :user, only: [:destroy], path: :users
    resources :blocks, only: [:index, :create, :destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
