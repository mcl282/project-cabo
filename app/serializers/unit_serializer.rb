class UnitSerializer < ActiveModel::Serializer
  attributes :id, :manager_id, :tenant_id, :property_id, :unit_name, :created_at 
end
