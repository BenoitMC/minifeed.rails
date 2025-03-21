Rails.application.routes.draw do
  root "home#home"
  resource :user_session, only: %i[new create destroy]

  resources :static_pages, path: "static-pages", only: [] do
    collection do
      get :"keyboard-shortcuts"
    end
  end

  resources :entries, only: [:index, :new, :create, :show, :update] do
    get :reader, on: :member
    get :iframe, on: :member
    post :"mark-all-as-read", on: :collection
  end

  namespace :settings do
    root "home#home"
    resource :account, only: [:edit, :update]
    resources :categories do
      match :reorder, via: [:get, :post], on: :collection
    end
    resources :feeds do
      get :search, on: :collection
    end
    resources :opml_imports, path: "opml-imports", only: [:new, :create]
    resources :opml_exports, path: "opml-exports", only: [:create]
    resources :users
  end

  namespace :api do
    namespace :v1 do
      root "home#home"
      resources :user_sessions, only: [:create]
      resources :entries, only: [:index, :create, :update] do
        post :"mark-all-as-read", on: :collection
      end
    end
  end

  match "*path" => "errors#not_found", :via => :all
end
