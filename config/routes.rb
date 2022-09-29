Rails.application.routes.draw do
  devise_for :users
  get 'carts/show'
  
  get 'carts' => 'carts#show'
  get 'cart' => 'carts#get_cart'
  post '/cart/add' => 'carts#add_item'
  delete '/cart/delete' => 'carts#remove_item'
  put '/cart/update' => 'carts#update_quantity'
  
  # Checkout routing
  get '/checkout' => 'checkout#show'
  get '/checkout/payment' => 'checkout#payment'
  get '/checkout/success' => 'checkout#order_page'
  get '/checkout/cancel' => 'checkout#cancel'
  
  # Stripe API
  post '/create-checkout-session' => 'checkout#create_checkout_session'
  post '/create-payment-intent' => 'checkout#create_payment_intent'
  post '/create-customer' => 'checkout#create_customer'
  
  # Admin dashboard
  namespace :admin do
    resources :products
    resources :categories
    get '' => 'dashboard#home'
    get '/search' => 'dashboard#search'
    get '/orders' => 'order#all'
    get '/orders/:order_id' => 'order#show'
    get '/customers' => 'customer#all'
    get '/customers/:customer_id/edit' => 'customer#show'
    put '/customers/edit_customer' => 'customer#edit_customer'
    
    put 'account/:account_id/update' => 'account#edit'
    get 'account/:account_id' => 'account#show'
    get 'accounts' => 'account#all'
    post '/new_search' => 'dashboard#search'
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
