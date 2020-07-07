# This migration comes from spree_tbk (originally 20200628212309)
class AddWebpayDataToSpreePayments < SpreeExtension::Migration[4.2]
  def up
    #execute 'CREATE EXTENSION IF NOT EXISTS hstore'
    #add_column :spree_payments, :webpay_params, :hstore
    add_column :spree_payments, :webpay_trx_id, :string
  end

  def down
    #remove_column :spree_payments, :webpay_params
    remove_column :spree_payments, :webpay_trx_id
    #execute 'DROP EXTENSION hstore'
  end
end
