class AddUnitRefToProperties < ActiveRecord::Migration[5.0]
  def change
    add_reference :properties, :unit, foreign_key: true
  end
end
