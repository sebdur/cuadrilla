class CreateQuoteCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :quote_costs do |t|
      t.string :name
      t.string :code
      t.integer :cost
      t.integer :service_delivery_code

      t.timestamps
    end
  end
end
