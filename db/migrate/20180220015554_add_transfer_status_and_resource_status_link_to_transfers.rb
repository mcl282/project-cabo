class AddTransferStatusAndResourceStatusLinkToTransfers < ActiveRecord::Migration[5.0]
  def change
    add_column :transfers, :transfer_status, :string
    add_column :transfers, :resource_status_link, :string
  end
end
