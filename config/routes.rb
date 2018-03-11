Rails.application.routes.draw do
  resources :newsposts
  resources :players
  resources :games, only: [:show, :create]
  resources :sessions, only: [:new, :create, :destroy]

  root  'static_pages#home'
  match '/signup', to: 'players#new', via: 'get'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/post', to: 'newsposts#new', via: 'get'

  match '/move/:id/cell=:cell', to: 'games#receive_move', via: 'get'
  match '/surrender/:id', to: 'games#surrender', via: 'get'

 end
