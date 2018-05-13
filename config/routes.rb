Rails.application.routes.draw do
  devise_for :users
  root "home#home"

  resources :static_pages, path: "static-pages", only: [] do
    collection do
      get :"keyboard-shortcuts"
    end
  end

  resources :entries, only: [:index, :show, :update] do
    get :preview, on: :member
    post :"mark-as-read", on: :collection
  end

  namespace :settings do
    root "home#home"
    resources :categories do
      match :reorder, via: [:get, :post], on: :collection
    end
    resources :feeds do
      match :search, via: [:get, :post], on: :collection
    end
    resources :opml_imports, path: "opml-imports", only: [:new, :create]
  end
end
