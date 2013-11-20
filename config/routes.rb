Trackncheese::Application.routes.draw do
  root :to => "home#index"
	match 'auth/:provider/callback', to: 'sessions#create', via: :all
	get 'auth/failure', to: 'sessions#failure'
	get 'signin', to: 'sessions#new', as: 'new_session'
	get 'signout', to: 'sessions#destroy', as: 'signout'
  resources :identities
  
	resources :projects do
		get 'single', on: :new
		get 'album',  on: :new
		resources :songs
	end
end
