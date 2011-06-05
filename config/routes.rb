UCC::Application.routes.draw do

    resources :users do
    resources :messages
    resources :wall_messages
    member do
      get :following, :followers
    resources :wall_messages

    end
    end
  resources :messages
  resources :relationships
  resources :sessions,      :only => [:new, :create, :destroy]
  resources :thoughts,    :only => [:create, :destroy]
    resources :wall_messages


  root :to => 'pages#home'
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/signup', :to => 'users#new'
  match '/recover', :to => 'recover#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'



end
