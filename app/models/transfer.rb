class Transfer < ApplicationRecord
  include DwollaAppToken
  
  belongs_to :transfer_term
  has_many :transfer_schedules

  @@dwolla = DwollaAppToken.get_token
  

  def self.create_transfer(source_url, destination_url, value, metadata)
    
    transfer_schedule_id = metadata[:transfer_schedule_id] 
    
    
    if transfer_schedule_id
      unique_key = transfer_schedule_id
    end
      


    request_body = {
      :_links => {
        :source => {
          :href => source_url
        },
        :destination => {
          :href => destination_url
        }
      },
      :amount => {
        :currency => "USD",
        :value => value
      },
      :metadata => metadata,
      
      :clearing => {
        :source => "standard",
        :destination => "next-available"
      }
    }
    
    idempotency_key = Digest::SHA256.hexdigest unique_key.to_s
    
    request_response = @@dwolla.post "transfers", request_body, {'Idempotency-Key': idempotency_key}
    
    status = request_response.response_status
    transfer_location = request_response.response_headers[:location]
    
    transfer = Transfer.new(
      link: transfer_location, 
      request_status_code: status,
      transfer_schedule_id: metadata[:transfer_schedule_id]
    )
    
    

    request_status_code = transfer.request_status_code
    
    if request_status_code == 201
      transfer.save 
      { :request_response => request_response,
        :transfer_id => transfer.id
      }
      
    end

  end
  
  
  def self.fetch_transfer(transfer_id)
    location = Transfer.find(transfer_id).link
    @@dwolla.get location
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
  
  def self.fetch_transfer_by_link(link)
    @@dwolla.get link
  end
  
  
  

end
