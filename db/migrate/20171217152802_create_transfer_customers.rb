class CreateTransferCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :transfer_customers do |t|
      t.references :user, foreign_key: true
      t.text :location
      t.string :transfer_customer_id

      t.timestamps
    end
  end
end
