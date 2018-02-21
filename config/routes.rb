Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :players
  resources :games, only: [:show]
  resources :sessions, only: [:new, :create, :destroy]

  root  'static_pages#home'
  match '/signup', to: 'players#new', via: 'get'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'

end
