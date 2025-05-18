Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }  
  root 'home#index'

  resources :meetings do
    member do
      get :cancel
    end
  end
  resources :meetings do
  resources :payments, only: [:create]
  end
  namespace :admin do
  get "dashboard", to: "dashboard#index"
  end
  namespace :admin do
  resources :meetings, only: [:index, :show]
  end

  get 'protected', to: 'messages#protected'
  get 'public', to: 'messages#public'
  get 'admin', to: 'messages#admin'

  get 'profile', to: 'users#profile'

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#server_error', via: :all
end
