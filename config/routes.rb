Rails.application.routes.draw do
  resources :drug_interactions
  resources :scheduled_doses
get 'signup', to: 'users#new', as: 'signup'
get 'login', to: 'sessions#new', as: 'login'
get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions
  resources :prescriptions
  resources :drugs
  resources :doctors
  resources :pharmacies
  resources :users
end
