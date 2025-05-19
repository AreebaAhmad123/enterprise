Rails.application.routes.draw do
  # Authentication
  devise_for :users, controllers: { registrations: 'registrations' }

  # Root and User Profile
  root 'home#index'
  get 'profile', to: 'users#profile'

  # Meetings
  # Nested under users for user-specific actions (index, new, create)
  resources :users, only: [] do
    resources :meetings, only: [:index, :new, :create]
  end

  # Top-level meetings for general actions and calendar
  resources :meetings, only: [:index, :show, :edit, :update, :destroy] do
    # Comments for meetings
    resources :comments, only: [:create]

    # Stripe payments
    resources :payments, only: [:create]

    # Custom meeting actions
    member do
      get :cancel          # GET /meetings/:id/cancel
      get :pay             # GET /meetings/:id/pay
      post :process_payment # POST /meetings/:id/process_payment
    end

    # Admin tools
    collection do
      get :export_csv     # GET /meetings/export_csv
    end
  end

  # Admin Namespace
  namespace :admin do
    get 'dashboard', to: 'dashboard#index' # Admin dashboard
    resources :meetings, only: [:index, :show, :destroy] # Admin meeting management
    resources :users, only: [:index, :show] # Admin user management
  end

  # Error Pages
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#server_error', via: :all
end