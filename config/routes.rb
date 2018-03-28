Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'top_page#index'
  get '/search', to: 'search#search'
  get '/toilet/:id', to: 'toilets#description' , as: 'toilet'

  post '/reviews', to: 'reviews#post', as: 'reviews'

  post '/edit', to: "toilets#edit", as: 'edit'

  devise_for :users, controllers: { :omniauth_callbacks => "omniauth_callbacks" }
end
