Rails.application.routes.draw do
  devise_for :users
  get 'carts/show'
  
  get 'carts' => 'carts#show'
  get 'cart' => 'carts#get_cart'
  post '/cart/add' => 'carts#add_item'
  delete '/cart/delete' => 'carts#remove_item'
  put '/cart/update' => 'carts#update_quantity'
  
  

  
  namespace :admin do
    resources :products
    resources :categories
  end
  
  get '/products' => "shops#index"
  get '/products/:product_id' => "shops#show"
  
  get '/collections' => "shops_categories#index"
  get '/collections/:collection_id' => "shops_categories#show"
  
  get '/collections/:collection_id/products/:product_id' => "shops#show"
  
  #resources :shops, only: [:index, :show]
  #resources :shops_categories
  resources :order_items
  resources :carts, only: [:show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  
  root "shops#home"
end
