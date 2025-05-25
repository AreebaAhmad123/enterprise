Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  
  root 'home#index'
  get 'profile', to: 'users#profile'
  
  devise_scope :user do
    get 'admin/sign_in', to: 'users/sessions#new_admin', as: :new_admin_session
    post 'admin/sign_in', to: 'users/sessions#create_admin', as: :admin_session
  end

  resources :users, only: [] do
    resources :meetings, only: [:index, :new, :create]
  end

  resources :meetings, only: [:index, :show, :edit, :update, :destroy] do
    resources :comments, only: [:create]
    resources :payments, only: [:create]
    member do
      match :cancel, via: [:get, :patch] # Changed to support GET and PATCH
      get :pay
      post :process_payment
    end
    collection do
      get :export_csv
    end
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :meetings, only: [:index, :show, :destroy]
    resources :users, only: [:index, :show]
  end

  # Dashboard routes
  get 'dashboard', to: 'dashboard#client'
  get 'dashboard/consultant', to: 'dashboard#consultant'

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#server_error', via: :all

  # Catch all undefined routes and redirect to 404
  match '*path', to: 'errors#not_found', via: :all
end