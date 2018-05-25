class RemoveUnitFromProperties < ActiveRecord::Migration[5.0]
  def change
    remove_column :properties, :unit, :string
  end
end
