Rails.application.routes.draw do
  devise_for :users
  root "home#home"

  resources :entries, only: [:index, :show, :update]
end
