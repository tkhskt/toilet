Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'top_page#index'
  get '/search', to: 'search#search'
  get '/toilet/:id', to: 'toilets#description' , as: 'toilet'

  post '/reviews', to: 'reviews#post', as: 'reviews'
end
