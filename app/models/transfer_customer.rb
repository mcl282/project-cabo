class TransferCustomer < ApplicationRecord
  belongs_to :user


    @@app_token = $dwolla.auths.client

    @@plaid = Plaid::Client.new(
          env: :sandbox,
          client_id: ENV["PLAID_CLIENT_ID"],
          secret: ENV["PLAID_SECRET"],
          public_key: ENV["PLAID_PUBLIC_KEY"]) 



  #create a transfer source
  def create_transfer_source(account_info, user_id)
  
    #exchange public token for an access token
    pub_token = account_info[:public_token]
    exchange_response = @@plaid.item.public_token.exchange(pub_token)
    access_token = exchange_response['access_token']
    item_id = exchange_response['item_id']  
   
    #Per Plaid:  access_tokens and item_ids are the core identifiers that map your end-users to their financial institutions. You should persist these securely and associate them with users of your application.   
    PlaidCredential.create(
    user_id:  user_id,
    access_token: access_token,
    item_id:  item_id
    )
    #exchange a plaid access token for a plaid processor token
    #incorrectly documneted by Plaid / Dwolla; see here:  https://github.com/plaid/plaid-ruby/issues/174
    
    plaid_dwolla_response = @@plaid.post_with_auth(
      'processor/dwolla/processor_token/create',
      access_token: access_token,
      account_id: account_info[:account_id])
    
    processor_token = plaid_dwolla_response['processor_token']      
  
    #Create a funding source for a Customer using a plaidToken, at Dwolla
    customer_url = TransferCustomer.dwolla_customer_url(user_id)
    
    account_name = account_info[:account_name]
    institution = account_info[:institution]
    account_type = account_info[:account_type]
      
    request_body = {
      plaidToken: processor_token,
      name: account_name + " @" + institution + " (type: " + account_type + ")"
    }
  
    @@app_token.post "#{customer_url}/funding-sources", request_body  
  end

#find transfer customer by user id  
  def self.customer(user_id)
    TransferCustomer.find_by(user_id: user_id)
  end
  
  def self.update_customer(customer_url, request_body)
    @@app_token.post customer_url, request_body
  end
  
#create array of all active funding sources  
  def active_funding_sources
    customer_url = self.location
    funding_sources = @@app_token.get "#{customer_url}/funding-sources?removed=false"

    funding_sources._embedded['funding-sources']
  end

  #only allow 1 funding source, array will always return with 1 for balance  
  def within_funding_source_limit?
    banks = active_funding_sources.map{|object| object["bankName"]}.compact
    banks.length < 1
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
  
  def self.retrieve_customer(user_id)
    customer_url = TransferCustomer.dwolla_customer_url(user_id)
    @@app_token.get customer_url
  end
  
  def self.create_transfer(transfer)
    
    request_body = {
      :_links => {
        :source => {
          :href => self.funding_source_url(transfer[:source_customer_id])
        },
        :destination => {
          :href => self.funding_source_url(transfer[:destination_customer_id])
        }
      },
      :amount => {
        :currency => "USD",
        :value => transfer[:value]
      },
      :metadata => {
        :paymentId => "tbu",
        :note => "tbu"
      },
      :clearing => {
        :source => "standard",
        :destination => "next-available"
      }
    }
    
    @@app_token.post "transfers", request_body
    
  end

end

