class CreateTransferSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :transfer_schedules do |t|
      t.references :transfer_term, foreign_key: true
      t.references :transfer, foreign_key: true
      t.string :status
      t.date :initialize_transfer_date
      t.integer :value_cents

      t.timestamps
    end
  end
end
