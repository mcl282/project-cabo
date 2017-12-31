class AddSourceIdToTransferSources < ActiveRecord::Migration[5.0]
  def change
    add_column :transfer_sources, :source_id, :string
  end
end
