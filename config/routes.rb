Rails.application.routes.draw do
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions, only: [:create, :destroy]
  resources :drugs, only: [:create]
  resources :refills, only: [:update]
  resources :prescriptions
  resources :users, except: [:destroy]
  root 'welcome#index'
end
