class Document < ApplicationRecord
  belongs_to :unit
  mount_uploader :document, DocumentUploader  
end
