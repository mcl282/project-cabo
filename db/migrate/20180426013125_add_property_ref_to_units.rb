class AddPropertyRefToUnits < ActiveRecord::Migration[5.0]
  def change
    add_reference :units, :property, foreign_key: true
  end
end
