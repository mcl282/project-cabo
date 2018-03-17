class AddTransferTermRefToTransfers < ActiveRecord::Migration[5.0]
  def change
    add_reference :transfers, :transfer_term, foreign_key: true
  end
end
