Rails.application.routes.draw do
  resources :newsposts
  resources :players
  resources :boards, only: [:show, :create, :update]
  resources :games, only: [:show, :create]
  resources :sessions, only: [:new, :create, :destroy]
  resources :comments, only: [:create, :destroy, :index]

  root  'static_pages#home'
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
  match '/comments/:id', to: 'players#comments', via: 'get'
  match '/approve/:id', to: 'comments#approve', via: 'post'
  match '/forgotten', to: 'players#forgotten', via: 'get'
  match '/reminder', to: 'players#create_new_password', via: 'post'
end
