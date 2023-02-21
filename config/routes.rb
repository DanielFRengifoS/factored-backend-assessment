Rails.application.routes.draw do
  post 'users', to: 'users#post'
  post 'user', to: 'users#validate'
  get 'user/:email', to: 'users#get'
  delete 'user', to: 'users#delete'
  put 'user', to: 'users#update'

  get 'films', to: 'films#index'
  get 'film/:id', to: 'films#get'
  post 'films', to: 'films#post'
  delete 'film/:id', to: 'films#delete'
  put 'film/:id', to: 'films#update'

  get 'people', to: 'people#index'
  get 'person/:id', to: 'people#get'
  post 'people', to: 'people#post'
  delete 'person/:id', to: 'people#delete'
  put 'person/:id', to: 'people#update'

  get 'planets', to: 'planets#index'
  get 'planet/:id', to: 'planets#get'
  post 'planets', to: 'planets#post'
  delete 'planet/:id', to: 'planets#delete'
  put 'planet/:id', to: 'planets#update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
