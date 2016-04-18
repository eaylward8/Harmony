Rails.application.routes.draw do
  # resources :drug_interactions
  # resources :scheduled_doses
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions
  resources :prescriptions
  # resources :drugs
  # resources :doctors
  # resources :pharmacies
  resources :users
  root 'welcome#index'
  get '/prescriptionsjson' => 'prescriptions#json', as: :prescriptionsJSON 
  get '/userrefillsjson' => 'users#refill_json', as: :refillJSON
end
