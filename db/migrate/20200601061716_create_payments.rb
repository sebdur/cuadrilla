class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments, force: :cascade do |t|
      t.string :description, limit: 255
      t.integer :amount, limit: 4
      t.datetime :pay_date
      t.boolean :verified
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.integer :user_id, limit: 4
      t.integer :payment_method_id, limit: 4
      t.string :tbk_transaction_id, limit: 255
      t.string :tbk_token, limit: 255
      t.string :state, limit: 255
      t.string :webpay_data, limit: 255

    end
  end
end
