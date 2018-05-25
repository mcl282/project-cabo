class AddUnitNameToUnits < ActiveRecord::Migration[5.0]
  def change
    add_column :units, :unit_name, :string
  end
end
