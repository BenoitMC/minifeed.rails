Rails.application.routes.draw do
  devise_for :users
  root "home#home"

  resources :entries, only: [:index, :show, :update] do
    post :"mark-as-read", on: :collection
  end
end
