Rails.application.routes.draw do
  post 'users', to: 'users#post'
  post 'user', to: 'users#validate'
  get 'user/:email', to: 'users#get'
  delete 'user', to: 'users#delete'
  put 'user', to: 'users#update'

  get 'films', to: 'films#index'
  get 'film/:id', to: 'films#get'
  get 'people', to: 'people#index'
  get 'person/:id', to: 'people#get'
  get 'planets', to: 'planets#index'
  get 'planet/:id', to: 'planets#get'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
