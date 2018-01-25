class Transfer < ApplicationRecord
  belongs_to :transfer_term

  @dwolla = $dwolla.auths.client

  def self.fetch_transfer(transfer_id)
    location = Transfer.find(transfer_id).link
    @dwolla.get location
  end

  def self.transfer_status(transfer_id)
    Transfer.fetch_transfer(transfer_id)['status']
  end
    
  def self.transfer_amount(transfer_id)
    amount = Transfer.fetch_transfer(transfer_id)['amount']
    {:value => amount['value'], :currency => amount['currency']}
  end
  
  def self.transfer_created_timestamp(transfer_id)
    Transfer.fetch_transfer(transfer_id)['created']
  end
  
end
