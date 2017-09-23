class CreatePurchases < ActiveRecord::Migration[5.0]
  def change
    create_table :purchases do |t|
      t.string :stripe_charge_id
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :purchases, [:stripe_charge_id, :user_id]
  end
end
