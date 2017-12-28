class TransferSource < ApplicationRecord
  belongs_to :user
  
  def self.funding_source_exists?(user_id)
    TransferSource.where(user_id: user_id).where.not(removed: true).exists?
  end
end
