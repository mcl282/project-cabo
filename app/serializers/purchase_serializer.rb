class PurchaseSerializer < ActiveModel::Serializer
  attributes :stripe_charge_id
end
