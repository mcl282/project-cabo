class CreateTransferTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :transfer_terms do |t|
      t.integer :monthly_amount_cents

      t.timestamps
    end
  end
end
