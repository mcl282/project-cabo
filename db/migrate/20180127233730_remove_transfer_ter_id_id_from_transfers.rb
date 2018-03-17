class RemoveTransferTerIdIdFromTransfers < ActiveRecord::Migration[5.0]
  def change
    remove_column :transfers, :transfer_term_id_id, :integer
  end
end
