class RenameRelationshipsToUnits < ActiveRecord::Migration[5.0]
  def change
    rename_table :Relationships , :Units
  end
end
