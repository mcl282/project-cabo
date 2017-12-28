class CreateTransferAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :transfer_accounts do |t|
      t.references :user, foreign_key: true
      t.string :funding_source_location

      t.timestamps
    end
  end
end
