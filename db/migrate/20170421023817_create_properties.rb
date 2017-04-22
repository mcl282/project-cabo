class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.string :street_number
      t.string :route
      t.string :unit
      t.string :locality
      t.string :administrative_area_level_1
      t.string :country
      t.string :postal_code
      t.string :google_place_id
      t.string :zillow_zpid

      t.timestamps
    end
  end
end
