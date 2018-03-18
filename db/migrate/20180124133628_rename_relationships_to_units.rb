class RenameRelationshipsToUnits < ActiveRecord::Migration[5.0]
  def change
    rename_table :relationships , :units
  end
end
