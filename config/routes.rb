Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }
  root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  resources :shrines, only: [:index, :show]

  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  namespace :admin do
    resources :shrines
  end
end
