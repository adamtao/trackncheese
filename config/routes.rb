Trackncheese::Application.routes.draw do
  root :to => "home#index"
	get 'auth/:provider/callback', to: 'sessions#create'
	get 'auth/failure', to: redirect('/')
	get 'signout', to: 'sessions#destroy', as: 'signout'
	resources :users do
		resources :projects do
			resources :songs
		end
	end
	resources :projects do
		get 'single', on: :new
		get 'album',  on: :new
	end
end
