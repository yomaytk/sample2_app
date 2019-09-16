Rails.application.routes.draw do

  get 'messages/create'
		root 'static_pages#home'
		get  '/help',    to: 'static_pages#help'
		get  '/about',   to: 'static_pages#about'
		get  '/contact', to: 'static_pages#contact'

		get  '/signup',  to: 'users#new'
		post '/signup',  to: 'users#create'

		get '/login', to: 'sessions#new'
		post '/login', to: 'sessions#create'
		delete '/logout', to: 'sessions#destroy'

		get '/password_resets', to: 'password_resets#new'
		get '/microposts',	to: 'static_pages#home'

		get  '/users/:id1/messages/:id2',  to: 'messages#show', id1: /\d+/, id2: /\d+/
		post '/users/:id1/messages/:id2',  to: 'messages#create', id1: /\d+/, id2: /\d+/
		# post '/messages/create', to: 'messages#create'

		resources  :users do
			member do
				get :following, :followers
			end
		end
		resources	 :account_activations, only: [:edit]
		resources	 :password_resets, only: [:new, :create, :edit, :update]
		resources	 :microposts, only: [:create, :destroy]
		resources  :relationships,       only: [:create, :destroy]
  end