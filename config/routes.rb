Rails.application.routes.draw do
  resources :newsposts
  resources :players
  resources :boards, only: [:show, :create, :update]
  resources :games, only: [:show, :create]
  resources :sessions, only: [:new, :create, :destroy]

  root  'static_pages#home'

  #get '/game/:id', to: 'games#show'
  #match '/randompositioning', to: 'games#create', via: 'post'
  #match '/play/:id', to: 'games#show', via: 'get'
  match '/signup', to: 'players#new', via: 'get'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/post', to: 'newsposts#new', via: 'get'

  match '/move/:id/cell=:cell', to: 'games#receive_move', via: 'get'
  match '/surrender/:id', to: 'games#surrender', via: 'get'

  match '/attempt/:id/:cell/', to: 'boards#place_ship', via: 'get'
  match '/direction/:id', to: 'boards#change_ship_direction', via: 'get'
  match '/forget/:id', to: 'boards#forget_board', via: 'get'
end
