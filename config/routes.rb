Rails.application.routes.draw do

  get 'password_resets/new'
  get 'password_resets/edit'
		root 'static_pages#home'
		get  '/help',    to: 'static_pages#help'
		get  '/about',   to: 'static_pages#about'
		get  '/contact', to: 'static_pages#contact'

		get  '/signup',  to: 'users#new'
		get  '/users/:id',  to: 'users#show', id: /\d+/
		post '/signup',  to: 'users#create'

		get '/login', to: 'sessions#new'
		post '/login', to: 'sessions#create'
		delete '/logout', to: 'sessions#destroy'

		get '/password_resets', to: 'password_resets#new'
		get '/microposts',	to: 'static_pages#home'
		
		resources  :users
		resources	 :account_activations, only: [:edit]
		resources	 :password_resets, only: [:new, :create, :edit, :update]
		resources	 :microposts, only: [:create, :destroy]
  end