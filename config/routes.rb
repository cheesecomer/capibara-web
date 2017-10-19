Rails.application.routes.draw do
  devise_for :users, only: []

  devise_scope :user do
    root to: 'sessions#new'
    resource :session, only: [:new, :create, :destroy], controller: :sessions
  end

  resources :rooms
  resources :users

  namespace :api, defaults: { format: :json } do
    resource :session, only: [:create, :destroy], controller: :sessions
    resources :rooms, only: [:index, :show]
    resource :user, only: [:create, :destroy, :update]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
