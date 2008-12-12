class CreatePstransactions < ActiveRecord::Migration
  def self.up
    create_table :pstransactions do |t|
      t.string :transaction_id
      t.string :seller_email
      t.string :ref
      t.string :freight_type
      t.string :freight_value
      t.string :extras
      t.string :annotation
      t.string :payment_type
      t.string :status
      t.string :cli_name
      t.string :cli_address
      t.string :cli_email
      t.string :cli_number
      t.string :cli_complement
      t.string :cli_district
      t.string :cli_city
      t.string :cli_state
      t.string :cli_zip
      t.string :cli_phone
      t.string :count_itens
      t.string :checked

      t.timestamps
    end
  end

  def self.down
    drop_table :pstransactions
  end
end
