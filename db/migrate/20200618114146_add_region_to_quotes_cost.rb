class AddRegionToQuotesCost < ActiveRecord::Migration[6.0]
  def change
    add_column :quote_costs, :region, :string
  end
end
