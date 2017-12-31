class RenameSourceId < ActiveRecord::Migration[5.0]
  def change
    rename_column :transfer_sources, :source_id, :dwolla_source_id
  end
end