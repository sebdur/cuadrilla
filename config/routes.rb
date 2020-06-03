Rails.application.routes.draw do
  get 'payments/webpay_success'
  get 'payments/webpay_error'
  get 'payments/webpay_nullify'
  resources :payments
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #WebPay 
  post '/webpay/webpay_final_url', :to => 'webpay#webpay_final_url', :as => :webpay_result
  post '/webpay/webpay_return_url', :to => 'webpay#webpay_return_url', :as => :webpay_return_url
  get 'webpay/success', :to => 'payments#webpay_success', :as => :webpay_success
  get 'webpay/error', :to => 'payments#webpay_error', :as => :webpay_error
  get 'webpay/nullify', :to => 'payments#webpay_nullify', :as => :webpay_nullify

end
