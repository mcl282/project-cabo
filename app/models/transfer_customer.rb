class TransferCustomer < ApplicationRecord
  belongs_to :user
  
  @@app_token = $dwolla.auths.client
  @@plaid = Plaid::Client.new(
        env: :sandbox,
        client_id: ENV["PLAID_CLIENT_ID"],
        secret: ENV["PLAID_SECRET"],
        public_key: ENV["PLAID_PUBLIC_KEY"]) 


#find transfer customer by user id  
  def self.customer(user_id)
    TransferCustomer.find_by(user_id: user_id)
  end
  
#create array of all active funding sources  
  def active_funding_sources
    customer_url = self.location
    funding_sources = @@app_token.get "#{customer_url}/funding-sources?removed=false"
    funding_sources["_embedded"]["funding-sources"]
  end
  
  def within_funding_source_limit?
    active_funding_sources.length < 1
  end
  
  def fetch_funding_source
    self.active_funding_sources[0]
  end
  
  def self.dwolla_customer_url(user_id)
    self.customer(user_id).location
  end
  
  def self.funding_source_url(user_id)
    self.customer(user_id).fetch_funding_source["_links"]["self"]["href"]
  end
  
  def self.update_funding_source(user_id, request_body)
    funding_source_url = self.funding_source_url(user_id)
    dwolla_update_responnse = @@app_token.post "#{funding_source_url}", request_body
    {
      :status => dwolla_update_responnse[:status],
      :type => dwolla_update_responnse[:type],
      :bankAccountType => dwolla_update_responnse[:bankAccountType],
      :name => dwolla_update_responnse[:name],
      :removed => dwolla_update_responnse[:removed],
      :channels => dwolla_update_responnse[:channels]
    }
  end
  
  


end
