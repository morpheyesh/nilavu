Nilavu::Application.routes.draw do
  resources :source_files, :only => [:index, :create, :destroy], :controller => 's3_uploads' do
    get :generate_key, :on => :collection
  end
  root to: 'cockpits#index'
  get '/404', to: 'errors#not_found'
  # get "/422", :to => "errors#unacceptable"
  get '/500', to: 'errors#internal_error'

  resources :users
  resources :sessions
  resources :cockpits
  resources :catalogs
  resources :marketplaces
  resources :ssh_keys
  resources :buckets
  resources :bucketkolkes
  resources :password_resets
  resources :billings
  resources :onetorpedos
  resources :oneapps
  resources :oneservices
  resources :onemicroservices
  resources :phones
  # Internal AJAX API
  resources :events

  # named route for users, session
  match '/signup', to: 'users#new', via: [:get]
  match '/signin', to: 'sessions#new', via: [:get]
  match '/tour', to: 'sessions#tour', via: [:get]
  match '/signout', to: 'sessions#destroy', via: [:post, :delete]
  match '/auth/facebook/callback', to: 'sessions#create', via: [:get, :post]
  match '/auth/google_oauth2/callback', to: 'sessions#create', via: [:get, :post]

  # named route for billing, paid message callback from paypal or bitcoin
  match '/billings_promo', to: 'billings#promo', via: [:get, :post]
  match '/invoice_pdf', to: 'billings#invoice_pdf', via: [:get, :post]
  match '/notify_payment', to: 'billings#notify_payment', via: [:get, :post]


  #=====github
  match '/auth/github/callback', to: 'marketplaces#store_github', via: [:get, :post]
  match '/publish_github', to: 'marketplaces#publish_github', via: [:get, :post]

  #=====Gitlab
  match 'store_gitlab', to: 'marketplaces#store_gitlab', via: [:post]
  match '/auth/gitlab',      to: 'marketplaces#start_gitlab', via: [:get, :post]
  match '/publish_gitlab',   to: 'marketplaces#publish_gitlab', via: [:get, :post]

  #===catalogs
  # kelvi   : confirm delete for all flycontrols. all cattypes will use that.
  match '/kelvi', to: 'catalogs#kelvi', via: [:post]
  match '/index', to: 'catalogs#index', via: [:get]

  #===Profiles
  match '/invite', to: 'users#invite', via: [:post]
  match '/accept_invite', to: 'users#accept_invite', via: [:get]

  #===One Overviews
  match '/bindservice', to: 'oneapps#show', via: [:get]

  #===Events
  match '/sensors', to: 'sensors#index' , via: [:get, :post]
end
