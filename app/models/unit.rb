class Unit < ApplicationRecord
  belongs_to :property
  belongs_to :tenant, class_name: "User"  
  belongs_to :manager, class_name: "User"
  has_many :documents

end
