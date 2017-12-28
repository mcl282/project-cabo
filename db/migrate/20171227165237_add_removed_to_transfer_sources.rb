class AddRemovedToTransferSources < ActiveRecord::Migration[5.0]
  def change
    add_column :transfer_sources, :removed, :boolean
  end
end
