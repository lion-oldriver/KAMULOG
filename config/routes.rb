Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }
  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  get "users/caution" => "users#caution"
  put "users/hide" => "users#hide", as: "users_hide"
  resources :users, only: [:show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  resources :shrines, only: [:index, :show] do
    resources :posts, except: [:index]
    resource :bookmarks, only: [:create, :destroy]
  end
  get "search" => "searches#search"

  # 管理者側のルーティング
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :shrines
    get "search_tag" => "shrines#search_tag"
  end
end
