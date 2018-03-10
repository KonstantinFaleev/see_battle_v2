Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :newsposts
  resources :players
  resources :games, only: [:show, :create]
  resources :sessions, only: [:new, :create, :destroy]

  root 'static_pages#home'
  #get 'games' => 'games#show'
  #match '/games', to: 'games#show', via: 'get'
  #get '/games/:id', to: 'games#show'
  match '/signup', to: 'players#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/post', to: 'newsposts#new', via: 'get'

  match '/move/:id/cell=:cell', to: 'games#receive_move', via: 'get'

 end
