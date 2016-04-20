Rails.application.routes.draw do
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions, only: [:create, :destroy]
  resources :prescriptions
  resources :users, except: [:destroy]
  root 'welcome#index'
  get '/prescriptionsjson' => 'prescriptions#json', as: :prescriptionsJSON 
  get '/userrefillsjson' => 'users#refill_json', as: :refillJSON
end
