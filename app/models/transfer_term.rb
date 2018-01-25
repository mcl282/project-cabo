class TransferTerm < ApplicationRecord
  has_many :transfers
  monetize :monthly_amount_cents
  
  @dwolla = $dwolla.auths.client
  
  def self.transfer(transfer_term_id)

    source_location = TransferCustomer.customer(40).fetch_funding_source._links['self']['href']
    destination_location = TransferCustomer.customer(41).fetch_funding_source._links['self']['href']
    terms = TransferTerm.find(transfer_term_id)
    value = terms.monthly_amount.format(:symbol => false)
    currency = terms.monthly_amount.currency.iso_code
    
    request_body = {
      :_links => {
        :source => {
          :href => source_location
        },
        :destination => {
          :href => destination_location
        }
      },
      :amount => {
        :currency => currency,
        :value => value 
      },
      :metadata => {
        :paymentId => "tbd",
        :note => "tbd"
      }
    }
    
    
    transfer = @dwolla.post "transfers", request_body
    Transfer.create(link: transfer.response_headers[:location]) 
  end
  
  def self.fetch_transfer(transfer_id)
    transfer_url = Tranfser.find(transfer_id).link
    @dwolla.get transfer_url
  end


end
