class RenameTransferAccountsToTransferSources < ActiveRecord::Migration[5.0]
  def change
    rename_table :transfer_accounts, :transfer_sources
  end
end
