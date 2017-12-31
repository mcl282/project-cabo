class DropTransferSource < ActiveRecord::Migration[5.0]
  def change
    drop_table :transfer_sources
  end
end
