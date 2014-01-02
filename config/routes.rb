Trackncheese::Application.routes.draw do
  root :to => "home#index"

	match '/calendar(/:year(/:month))' => 'calendar#index', as: :calendar, constraints: { year: /\d{4}/, month: /\d{1,2}/}, via: :all

	match 'auth/:provider/callback', to: 'sessions#create', via: :all
	get 'auth/failure', to: 'sessions#failure'
	get 'signin', to: 'sessions#new', as: 'new_session'
	get 'signout', to: 'sessions#destroy', as: 'signout'
  resources :identities
  
	resources :projects do
		get 'single', on: :new
		get 'album',  on: :new
		resources :tasks do 
			member do
				get :toggle
			end
		end
		resources :songs do 
			resources :tasks do 
				member do 
					get :toggle
				end
			end
			resources :song_attachments
		end
	end
end
