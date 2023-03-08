Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
devise_for :users
  root to: 'homes#top'
  get "home/about"=>"homes#about"

  resources :users, only: [:index,:show,:edit,:update] do
    member do
    get 'followings' => 'relationships#followings', as:'followings'
    get 'followers' => 'relationships#followers' , as:'followers'

    end
    resource :relationships, only: [:create,:destroy]
    get "search" => "users#search"
  end

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
  resources :book_comments, only: [:create,:destroy]
  resource :favorites, only: [:create, :destroy]
  end

  get "search" => "searches#search" , as:'search'
  get "searches/index"=> "searches#index"
  resources :groups, except: [:destroy]

  resources :chats, only: [:show, :create]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end