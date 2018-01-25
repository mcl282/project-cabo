class AddTransferTermIdToTransfers < ActiveRecord::Migration[5.0]
  def change
    add_reference :transfers, :transfer_term_id, foreign_key: true
  end
end
