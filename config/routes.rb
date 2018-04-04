Rails.application.routes.draw do
  devise_for :users, only: []

  devise_for :admins, only: []
  devise_scope :admin do
    resource :session, only: [:new, :create, :destroy], controller: :sessions
    get '/session', to: 'sessions#new'
  end

  resource :dashboard, only: [:show]
  resources :informations do
    post :preview, on: :collection
  end
  resources :inquiries, except: [:edit, :destroy]
  resources :rooms
  resources :reports, only: [:index, :show]

  resource :welcom, only: [:show]
  resource :privacy_policy, only: [:show]
  resource :terms, only: [:show]

  get '/inquiries', to: 'welcoms#show'

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
