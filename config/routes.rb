Rails.application.routes.draw do
  resources :payments
  resources :about, only: [:index]
  resources :messages, only: [:index, :create]
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  mount Spree::Core::Engine, at: '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #WebPay
  post '/webpay/webpay_final_url', :to => 'webpay#webpay_final_url', :as => :webpay_result
  post '/webpay/webpay_return_url', :to => 'webpay#webpay_return_url', :as => :webpay_return_url
  get 'webpay/success', :to => 'payments#webpay_success', :as => :webpay_success
  get 'webpay/error', :to => 'payments#webpay_error', :as => :webpay_error
  get 'webpay/nullify', :to => 'payments#webpay_nullify', :as => :webpay_nullify

end
