Rails.application.routes.draw do
  devise_for :users, only: []

  resource :welcom, only: [:show]
  resources :informations, only: [:index, :show]
  resource :privacy_policy, only: [:show]
  resources :inquiries, only: [:new, :create]
  resource :terms, only: [:show]
  get '/inquiries', to: 'welcoms#show'

  devise_for :admins, only: []
  devise_scope :admin do
    resource :session, only: [:new, :create, :destroy], controller: :sessions
    get '/session', to: 'sessions#new'

    resource :dashboard, only: [:show]
  end

  namespace :api, defaults: { format: :json } do
    resource :session, only: [:show, :create, :destroy], controller: :sessions
    resources :rooms, only: [:index, :show]
    resources :informations, only: [:index]
    resources :users, only: [:show]
    resource :user, only: [:create, :update, :destroy], path: :users
    resources :blocks, only: [:index, :create, :destroy]
    resources :reports, only: [:create]
    resources :inquiries, only: [:create]
    resources :oauth, only: [], param: :provider do
      get 'callback', on: :member
    end
  end

  root to: 'welcoms#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
