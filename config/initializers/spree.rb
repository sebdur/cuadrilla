require 'my_store/product_search'

 Rails.application.config.spree.calculators.shipping_methods << MyStore::Calculator::Shipping::CustomShippingCalculator
# config/initializers/spree.rb

# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  config.searcher_class = MyStore::ProductSearch
  config.logo = 'lacuadrilla2.png'
  config.admin_interface_logo = 'lacuadrilla2.png'
  config.admin_show_version = false
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  config.track_inventory_levels = false
  config.currency = 'CLP'
end

# Configure Spree Dependencies
#
# Note: If a dependency is set here it will NOT be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will make the dependency value go away.
#
Spree.dependencies do |dependencies|
  # Example:
  # Uncomment to change the default Service handling adding Items to Cart
  # dependencies.cart_add_item_service = 'MyNewAwesomeService'
end


Spree.user_class = "Spree::User"
