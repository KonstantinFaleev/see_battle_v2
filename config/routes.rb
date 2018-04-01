Rails.application.routes.draw do
  resources :newsposts
  resources :players
  resources :boards, only: [:show, :create, :update]
  resources :games, only: [:show, :create]
  resources :sessions, only: [:new, :create, :destroy]
  resources :comments, only: [:create, :destroy, :index]

  root 'static_pages#home'
  get '/games', to: 'games#show'
  #get '/show/:id', to: 'games#show'
  get '/signup', to: 'players#new'
  get '/about', to: 'static_pages#about'
  get '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  get '/post', to: 'newsposts#new'

  get '/move/:id/cell=:cell', to: 'games#receive_move'
  get '/surrender/:id', to: 'games#surrender'

  get '/attempt/:id/:cell/', to: 'boards#place_ship'
  get '/direction/:id', to: 'boards#change_ship_direction'
  get '/forget/:id', to: 'boards#forget_board'
  get '/comments/:id', to: 'players#comments'
  match '/approve/:id', to: 'comments#approve', via: 'post'
  get '/forgotten', to: 'players#forgotten'
  match '/reminder', to: 'players#create_new_password', via: 'post'
end
