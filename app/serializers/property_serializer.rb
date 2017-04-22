class PropertySerializer < ActiveModel::Serializer
  attributes :id, :street_number, :route, :unit, :locality, :administrative_area_level_1, :country, :postal_code, :google_place_id, :zillow_zpid 
end
