class CreatePsproducts < ActiveRecord::Migration
  def self.up
    create_table :psproducts do |t|
      t.string :pstransaction_id
      t.string :product_id
      t.string :description
      t.string :price
      t.string :quantity
      t.string :freight_value
      t.string :extra

      t.timestamps
    end
  end

  def self.down
    drop_table :psproducts
  end
end
