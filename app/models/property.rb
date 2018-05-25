class Property < ApplicationRecord
  has_many :units
  
  accepts_nested_attributes_for :units
  
  def find_property_by_address(property_data)
    Property.where(
      :street_number => property_data[:street_number], 
      :route => property_data[:route], 
      :locality => property_data[:locality], 
      :administrative_area_level_1 => property_data[:administrative_area_level_1], 
      :country => property_data[:country], 
      :postal_code => property_data[:postal_code], 
      :google_place_id => property_data[:google_place_id],
      :user_id => property_data[:user_id])
  end
  
  
end
