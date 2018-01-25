class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.integer :manager_id
      t.integer :tenant_id

      t.timestamps
    end
    add_index :relationships, :manager_id
    add_index :relationships, :tenant_id
    add_index :relationships, [:manager_id, :tenant_id ], unique: true
  end
end
