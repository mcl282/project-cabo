module Api::V1
  class TransferSourcesController < ApiController
    before_action :authenticate_user, :initiateDwolla, :initiatePlaid

    def index
      
      customer = TransferCustomer.customer(current_user.id)
      
      funding_source = customer.fetch_funding_source

      render json: {funding_source_data: funding_source, user: current_user.id}, status: :ok 
      
    end
    
    def create
      customer = TransferCustomer.customer(current_user.id)
      
      #before creating, check to see if a valid funding source already exists
      halt 500, "Over funding source limit!" unless customer.within_funding_source_limit?
      

      #pull the public token and account id off of the incoming request
      account_info = {
        :public_token => params[:values][:public_token],
        :account_id => params[:values][:account_id],
        :account_name => params[:values][:accounts][0]['name'],
        :account_type => params[:values][:accounts][0]['type'],
        :institution => params[:values][:institution]['name']
      }
      
      # exchange public token for an access token
      exchange_public_token_for_access_token(account_info[:public_token])

      #Per Plaid:  access_tokens and item_ids are the core identifiers that map your end-users to their financial institutions. You should persist these securely and associate them with users of your application. 
      PlaidCredential.create(
        user_id:  current_user.id,
        access_token: @access_token,
        item_id:  @item_id
        )

      create_dwolla_funding_source(account_info, current_user.id)

      render status: :created        
      
      rescue Exception => e
      
      render json: e[:message].to_json, status: :bad_request
    end
    
    def update
      #pull values off the update request
      request_body = request[:values]
      
      #update method
      update_funding_source_response = TransferCustomer.update_funding_source(current_user.id, request_body)

      render json: update_funding_source_response, status: :created        
      
    end

  private
    def initiateDwolla
      @app_token = $dwolla.auths.client
    end
    
    def initiatePlaid
      #create instance of plaid
      @plaid = Plaid::Client.new(
        env: :sandbox,
        client_id: ENV["PLAID_CLIENT_ID"],
        secret: ENV["PLAID_SECRET"],
        public_key: ENV["PLAID_PUBLIC_KEY"]) 
    end
    
    def exchange_public_token_for_access_token(pub_token)
      exchange_response = @plaid.item.public_token.exchange(pub_token)
      @access_token = exchange_response['access_token']
      @item_id = exchange_response['item_id']
    end
    
    def create_dwolla_funding_source(account_info, user_id)
      #exchange a plaid access token for a plaid processor token
      #incorrectly documneted by Plaid / Dwolla; see here:  https://github.com/plaid/plaid-ruby/issues/174
      
      plaid_dwolla_response = @plaid.post_with_auth(
        'processor/dwolla/processor_token/create',
        access_token: @access_token,
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

      @funding_source = @app_token.post "#{customer_url}/funding-sources", request_body

    end

  
  end
end

