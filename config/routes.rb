Rails.application.routes.draw do
  resources :prescriptions
  resources :drugs
  resources :doctors
  resources :pharmacies
  resources :users
end
